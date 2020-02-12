//
//  Edgerunner.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/23/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

typealias EditableModel = CharacterDescriptionModel & StatsModel & SkillModel & DamageModel & ArmorModel

/// The model for the Edgerunner character.
/// TODO: Move responsibilities of modifying this model to another class. Don't let it manage itself.
final class Edgerunner: Codable, EditableModel {
    
    private(set) var name: String
    private(set) var handle: String
    
    /// The Edgerunner stats assigned at creation. These stats are immutable according to game rules; you must
    /// update the stat via set(stats: Stats). These are the raw, base stats. Use value(for: Stat) to retrieve
    /// the calculated stat values includng pentalties
    private(set) var baseStats: Stats
    
    /// Character role, aka "Class"
    private(set) var role: Role
    
    /// All skills available to a Edgerunner
    private(set) var skills: [SkillListing]
    
    /// Damage on the Edgerunner
    private(set) var damage: Int
    
    /// The Edgerunner's save value for Stun or Mortal saves
    private(set) var save: Int
    
    /// The Edgerunner's Body Type
    private(set) var bodyType: BodyType
    
    /// The Edgerunner's BTM
    private(set) var btm: Int
    
    /// The Wounds the edgerunner has sustained
    private(set) var wounds: [Wound] = [Wound]()
    
    private var baseHumanity: Int {
        return baseStats.emp * 10
    }
    
    /// The humanity deficit incurred by Cyberware
    private(set) var humanityLoss: Int
    
    private(set) var equippedArmor = EquippedArmor()

    // MARK: Modifiers

    /// Collection of stat modifiers
    private(set) var statModifiers = [StatModifier]()
    
    /// Collection of skill modifiers
    private(set) var skillModifiers = [SkillModifier]()
    
    /// Collection of arbitrary modifiers (currently unused)
    private(set) var arbitraryModifiers = [ArbitraryModifier]()
    
    // MARK: Save Rolls and Stun/Death state
    
    /// Collection of save rolls that must be performed
    private(set) var saveRolls = [SaveRoll]()
    
    /// Indicates the state of the player
    private(set) var livingState: LivingState = .alive
    
    /// Creates a blank character before naming.
    ///
    /// - Parameter baseStats: The Base Stats of the character
    /// - Parameter role: The Role of the character
    /// - Parameter humanityLoss: Humanity loss of the character
    /// - Parameter skills: The Skills belonging to the character
    init(baseStats: Stats, role: Role, humanityLoss: Int, skills: [Skill]) {
        self.baseStats = baseStats
        self.role = role
        self.humanityLoss = humanityLoss
        damage = 0
        name = ""
        handle = ""
        save = baseStats.body
        bodyType = BodyType.from(bodyPointValue: baseStats.body)
        btm = bodyType.btm()
        self.skills = [SkillListing]() // This is necessary so we can set it on the next line and preserve this class as Codable.
        self.skills = skills.map({ SkillListing(skill: $0, points: 0, modifier: 0, statModifier: value(for: $0.linkedStat).displayValue)})
        addSubscribers()
    }
    
    /// Retrieves the value for the stat requested
    ///
    /// - Parameter stat: The stat you want
    /// - Returns: The value for the requested stat
    func value(for stat: Stat?) -> (baseValue: Int, displayValue: Int) {
        guard let stat = stat else { return (baseValue: 0, displayValue: 0) }
        
        switch stat {
        case .Intelligence:
            return (baseValue: baseStats.int, displayValue: (baseStats.int + modifier(for: .Intelligence)).zeroFloor())
        case .Reflex:
            return (baseValue: baseStats.ref, displayValue: (baseStats.ref + modifier(for: .Reflex)).zeroFloor())
        case .Tech:
            return (baseValue: baseStats.tech, displayValue: (baseStats.tech + modifier(for: .Tech)).zeroFloor())
        case .Cool:
            return (baseValue: baseStats.cool, displayValue: (baseStats.cool + modifier(for: .Cool)))
        case .Attractiveness:
            return (baseValue: baseStats.attr, displayValue: (baseStats.attr + modifier(for: .Attractiveness)).zeroFloor())
        case .Luck:
            return (baseValue: baseStats.luck, displayValue: (baseStats.luck + modifier(for: .Luck)).zeroFloor())
        case .MovementAllowance:
            return (baseValue: baseStats.ma, displayValue: (baseStats.ma + modifier(for: .MovementAllowance)).zeroFloor())
        case .Body:
            return (baseValue: baseStats.body, displayValue: (baseStats.body + modifier(for: .Body)).zeroFloor())
        case .Empathy:
            // TODO: Cyberpsychosis
            let empathyDouble: Double = Double(value(for: .Humanity).displayValue) / 10.0
            let empathy: Int = {
                if empathyDouble < 1.0 && empathyDouble > 0 {
                    return 1
                }
                else if empathyDouble < 0 {
                    return 0
                }
                else {
                    return Int(empathyDouble.rounded(.down))
                }
            }()
            return (baseValue: baseStats.emp, displayValue: (empathy < 0 ? 0 : empathy).zeroFloor())
        case .Run:
            let runValue = value(for: .MovementAllowance).displayValue * 3
            return (baseValue: runValue, displayValue: (runValue).zeroFloor())
        case .Leap:
            let leapValue = value(for: .Run).displayValue / 4
            return (baseValue: leapValue, displayValue: (leapValue).zeroFloor())
        case .Lift:
            let liftValue = value(for: .Body).displayValue * 40
            return (baseValue: liftValue, displayValue: (liftValue).zeroFloor())
        case .Reputation:
            return (baseValue: baseStats.rep, displayValue: (baseStats.rep + modifier(for: .Reputation)).zeroFloor())
        case .Humanity:
            return (baseValue: baseHumanity, displayValue: (baseHumanity - humanityLoss).zeroFloor())
        }
    }
    
    /// Returns the name of the Special Ability for the role.
    ///
    /// - Returns: Name of the Special Ability
    func specialAbilityName() -> String {
        return role.specialAbility()
    }
    
    // MARK: EditableModel
    
    /// Adds the skill to the character, overwriting if the skill already exists.
    ///
    /// - Parameters:
    ///   - newSkill: The new skill to add.
    ///   - validationCompletion: Completion for validating the skill
    func add(skill newSkill: SkillListing, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        guard CharacterValidator.validate(skillListing: newSkill, completion: completion) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let existingSkillIndex = self.skills.firstIndex(where: { $0.skill == newSkill.skill }) {
                self.skills.remove(at: existingSkillIndex)
            }
            
            self.skills.append(newSkill)

            completion(.success(.valid))
            NotificationCenter.default.post(name: .skillDidChange, object: newSkill)
            self.saveCharacter()
        }
    }
    
    /// Resets the skill to zero, using its default values
    /// - Parameters:
    ///   - skillListing: The Skill to reset
    ///   - validationCompletion: Completion for validating the skill
    func reset(skill skillListing: SkillListing, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        // TODO: When chipped skills are added, there will have to be a warning regarding this
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let existingSkillIndex = self.skills.firstIndex(where: { $0.skill == skillListing.skill }) {
                self.skills.remove(at: existingSkillIndex)
            }
            
            let skill = SkillListing(skill: skillListing.skill,
                                     points: 0,
                                     modifier: 0,
                                     statModifier: self.value(for: skillListing.skill.linkedStat).displayValue)
            
            self.skills.append(skill)
            
            completion(.success(.valid))
            NotificationCenter.default.post(name: .skillDidChange, object: skill)
            self.saveCharacter()
        }
    }
    
    /// Flips the star state of the skill
    /// - Parameters:
    ///   - skillListing: The Skill to flip the star state
    ///   - validationCompletion: Completion for validating the skill
    func flipStar(skill skillListing: SkillListing, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                let currentState = self.skills.first(where: { $0.skill == skillListing.skill } )?.starred else {
                    return
            }
            
            self.skills.first(where: { $0.skill == skillListing.skill } )?.starred = !currentState
            completion(.success(.valid))
            NotificationCenter.default.post(name: .skillDidChange, object: skillListing)
            self.saveCharacter()
        }

    }
    
    /// Updates the stats. This should only be called if editing the character.
    /// Stats are immutable during normal gameplay.
    ///
    /// - Parameters:
    ///   - baseStats: The base stats
    ///   - humanityLoss: Humanity loss
    ///   - validationCompletion: Completion for validating the skill
    func set(baseStats: Stats, humanityLoss: Int, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        guard CharacterValidator.validate(baseStats: baseStats, humanityLoss: humanityLoss, completion: completion) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.baseStats = baseStats
            self.bodyType = BodyType.from(bodyPointValue: baseStats.body)
            self.btm = self.bodyType.btm()
            self.save = baseStats.body
            self.humanityLoss = humanityLoss
            self.refreshSkillListings()
            
            completion(.success(.valid))
            NotificationCenter.default.post(name: .statsDidChange, object: nil)
            self.saveCharacter()
        }
    }
    
    /// Updates the character role. Call this when editing the character, otherwise
    /// this value should be immutable during normal gameplay.
    ///
    /// - Parameters:
    ///   - role: The new Edgerunner role
    ///   - validationCompletion: Completion for validating the skill
    func set(role: Role, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        DispatchQueue.main.async {
            self.role = role
            completion(.success(.valid))
            NotificationCenter.default.post(name: .roleDidChange, object: nil)
            self.saveCharacter()
        }
    }
    
    func set(name: String, handle: String, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        DispatchQueue.main.async {
            self.name = name
            self.handle = handle
            completion(.success(.valid))
            NotificationCenter.default.post(name: .nameAndHandleDidChange, object: nil)
            self.saveCharacter()
        }
    }
    
    func apply(damage: IncomingDamage, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        guard CharacterValidator.validate(incomingDamage: damage, currentDamage: self.damage, completion: completion) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let newWounds = DamageHelper.applyArmorDamage(to: self, incomingDamage: damage)
            self.wounds.append(contentsOf: newWounds)
            
            if newWounds.contains(where: { $0.isFatal()} ) {
                self.livingState = .dead0
                NotificationCenter.default.post(name: .livingStateDidChange, object: nil)
            }
            else {
                self.saveRolls.append(contentsOf: self.sortedSaveRolls(from: newWounds))
                NotificationCenter.default.post(name: .saveRollsDidChange, object: nil)
            }
            
            self.woundsChanged()
            
            completion(.success(.valid))

            NotificationCenter.default.post(name: .statsDidChange, object: nil)
            NotificationCenter.default.post(name: .damageDidChange, object: nil)
            
            self.saveCharacter()
        }
    }

    func remove(_ wound: Wound, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                let woundIndex = self.wounds.firstIndex(of: wound)
                else {
                    return
            }
            
            self.wounds.remove(at: woundIndex)
            
            self.woundsChanged()
            
            completion(.success(.valid))

            NotificationCenter.default.post(name: .statsDidChange, object: nil)
            NotificationCenter.default.post(name: .damageDidChange, object: nil)
            
            self.saveCharacter()
        }
    }
    
    func removeAll(_ traumaType: TraumaType, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                self.wounds.contains(where: { $0.traumaType == traumaType }) else {
                return
            }
            
            self.wounds.forEach { wound in
                if wound.traumaType == traumaType, let woundIndex = self.wounds.firstIndex(of: wound) {
                    self.wounds.remove(at: woundIndex)
                }
            }
            
            self.woundsChanged()
            
            completion(.success(.valid))

            NotificationCenter.default.post(name: .statsDidChange, object: nil)
            NotificationCenter.default.post(name: .damageDidChange, object: nil)
            
            self.saveCharacter()
        }
    }
    
    
    func reduce(wound: Wound, amount: Int, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                let woundIndex = self.wounds.firstIndex(of: wound)
                else {
                    return
            }
            
            guard wound.damageAmount > amount else {
                self.remove(wound, validationCompletion: completion)
                return
            }
            
            let oldWound = self.wounds.remove(at: woundIndex)
            let newWound = Wound(traumaType: oldWound.traumaType, damageAmount: oldWound.damageAmount - amount, location: oldWound.location)
            
            self.wounds.insert(newWound, at: woundIndex)
            
            self.woundsChanged()
            
            completion(.success(.valid))

            NotificationCenter.default.post(name: .statsDidChange, object: nil)
            NotificationCenter.default.post(name: .damageDidChange, object: nil)
            
            self.saveCharacter()
        }
    }
    
    func clearSaveRolls() {
        DispatchQueue.main.async {
            self.saveRolls.removeAll()
            NotificationCenter.default.post(name: .saveRollsDidChange, object: nil)
            // NEXT: Build interrupting trigger in coordinator to pop the save roll popover immediately
        }
    }

    func enter(livingState: LivingState) {
        DispatchQueue.main.async {
            self.livingState = livingState
            NotificationCenter.default.post(name: .livingStateDidChange, object: nil)
            // NEXT: Build interrupting trigger in coordinator to pop the death popover immediately
        }
    }
    
    
    private func woundsChanged() {
        self.damage = self.wounds.map({$0.damageAmount}).reduce(0, { $0 + $1 })

        self.statModifiers.removeAll(where: { $0.damageRelated })
        
        let modifiers = Rules.Damage.statModifiers(forTotalDamage: self.damage, baseStats: self.baseStats)
        
        self.statModifiers.append(contentsOf: modifiers)
        self.refreshSkillListings()
    }
    
    /// Refreshes each skill listing
    private func refreshSkillListings() {
        for skillListing in skills {
            guard let stat = skillListing.skill.linkedStat,
                skillListing.statModifier != value(for: stat).displayValue else {
                continue
            }
            
            skillListing.update(statModifierPoints: value(for: stat).displayValue)
        }
    }
    
    private func modifier(for stat: Stat) -> Int {
        return statModifiers.filter({ $0.stat == stat }).reduce(0, { total, next in
            total + next.amount
        })
    }
    
    private func modifier(for skill: Skill) -> Int {
        return skillModifiers.filter({ $0.skill == skill }).reduce(0, { total, next in
            total + next.amount
        })
    }
    
    private func sortedSaveRolls(from wounds: [Wound]) -> [SaveRoll] {
        guard let woundTrackState = Rules.Damage.wound(forTotalDamage: damage) else { return [SaveRoll]() }
        
        let saveRollTypes = woundTrackState.saveRollTypes()
        let stunPenalty = Rules.Damage.stunValue(forTotalDamage: damage) ?? 0
        let mortalPenalty = Rules.Damage.mortalValue(forTotalDamage: damage) ?? 0
        let bodyValue = value(for: .Body).displayValue
        
        var saveRolls = [SaveRoll]()
        
        // First, you should track all immediate mortal checks
    
        wounds.forEach { wound in
            // Immediately mortal wounds are special cases where the player must roll at Mortal0
            if wound.isMortal() {
                let saveRoll = SaveRoll(type: .Mortal, target: bodyValue, diceRoll: .d10())
                saveRolls.append(saveRoll)
            }
        }
        
        // Then, append the rolls of wherever you are in the woundTrack track.
        
        saveRolls.append(contentsOf: saveRollTypes.map({ type in
            let target: Int
            
            switch type {
            case .Mortal:
                target = (bodyValue - mortalPenalty).zeroFloor()
            case .Stun:
                target = (bodyValue - stunPenalty).zeroFloor()
            }
            
            return SaveRoll(type: type, target: target, diceRoll: .d10())
        }))
        
        return saveRolls
    }
    
    /// Called when reflex refresh is needed.
    @objc private func updateReflex() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.statModifiers.removeAll(where: { $0.evRelated })
            
            let reflexModifier = Rules.WornArmor.statModifier(forEV: self.equippedArmor.encumberancePenalty)
            self.statModifiers.append(reflexModifier)
            
            self.refreshSkillListings()
            
            NotificationCenter.default.post(name: .statsDidChange, object: nil)
            self.saveCharacter()
        }
        
    }
    
    /// Saves the character to disk.
    @objc private func saveCharacter() {
        guard let JSONData = JSONFactory().encode(with: self) else { return }
        NotificationCenter.default.post(name: .saveToDiskRequested, object: JSONData)
    }
    
    // MARK: Codable Initializer
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        handle = try container.decode(String.self, forKey: .handle)
        
        baseStats = try container.decode(Stats.self, forKey: .baseStats)
        role = try container.decode(Role.self, forKey: .role)
        skills = try container.decode([SkillListing].self, forKey: .skills)
        
        damage = try container.decode(Int.self, forKey: .damage)
        save = try container.decode(Int.self, forKey: .save)

        bodyType = try container.decode(BodyType.self, forKey: .bodyType)
        btm = try container.decode(Int.self, forKey: .btm)
        
        humanityLoss = try container.decode(Int.self, forKey: .humanityLoss)

        statModifiers = try container.decode([StatModifier].self, forKey: .statModifiers)
        skillModifiers = try container.decode([SkillModifier].self, forKey: .skillModifiers)
        arbitraryModifiers = try container.decode([ArbitraryModifier].self, forKey: .arbitraryModifiers)
        
        saveRolls = try container.decode([SaveRoll].self, forKey: .saveRolls)
        livingState = try container.decode(LivingState.self, forKey: .livingState)
        
        // Used for updates to the Edgerunner model.
        do {
            equippedArmor = try container.decode(EquippedArmor.self, forKey: .equippedArmor)
            wounds = try container.decode([Wound].self, forKey: .wounds)
        } catch let error {
            print("JSON mismatched the current Edgerunner model. The model has been updated.")
            print("Original error:\n\(error)")
            saveCharacter()
        }
        
        addSubscribers()
    }
    
    private func addSubscribers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateReflex), name: .armorDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveCharacter), name: .characterComponentDidRequestSaveToDisk, object: nil)
    }
}
