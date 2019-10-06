//
//  Edgerunner.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/23/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

typealias EditableModel = CharacterDescriptionModel & StatsModel & SkillModel & DamageModel

/// The model for the player character
final class Edgerunner: Codable, EditableModel {
    
    private(set) var name: String
    private(set) var handle: String
    
    /// The player stats assigned at creation. These stats are immutable according to game rules; you must
    /// update the stat via set(stats: Stats). These are the raw, base stats. Use value(for: Stat) to retrieve
    /// the calculated stat values includng pentalties
    private(set) var baseStats: Stats
    
    /// Character role, aka "Class"
    private(set) var role: Role
    
    /// All skills available to a player
    private(set) var skills: [SkillListing]
    
    /// Damage on the player
    private(set) var damage: Int
    
    /// The player's save value for Stun or Mortal saves
    private(set) var save: Int
    
    /// The player's Body Type
    private(set) var bodyType: BodyType
    
    /// The player's BTM
    private(set) var btm: Int
    
    private var baseHumanity: Int {
        return baseStats.emp * 10
    }
    
    /// The humanity deficit incurred by Cyberware
    private(set) var humanityLoss: Int
    
    /// Collection of stat modifiers
    private(set) var statModifiers = [StatModifier]()
    
    /// Collection of skill modifiers
    private(set) var skillModifiers = [SkillModifier]()
    
    /// Collection of arbitrary modifiers (currently unused)
    private(set) var arbitraryModifiers = [ArbitraryModifier]()
    
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
    }
    
    /// Retrieves the value for the stat requested
    ///
    /// - Parameter stat: The stat you want
    /// - Returns: The value for the requested stat
    func value(for stat: Stat?) -> (baseValue: Int, displayValue: Int) {
        guard let stat = stat else { return (baseValue: 0, displayValue: 0) }
        
        switch stat {
        case .Intelligence:
            return (baseValue: baseStats.int, displayValue: cantGoBelowZero(int: baseStats.int + modifier(for: .Intelligence)))
        case .Reflex:
            return (baseValue: baseStats.ref, displayValue: cantGoBelowZero(int: baseStats.ref + modifier(for: .Reflex)))
        case .Tech:
            return (baseValue: baseStats.tech, displayValue: cantGoBelowZero(int: baseStats.tech + modifier(for: .Tech)))
        case .Cool:
            return (baseValue: baseStats.cool, displayValue: cantGoBelowZero(int: baseStats.cool + modifier(for: .Cool)))
        case .Attractiveness:
            return (baseValue: baseStats.attr, displayValue: cantGoBelowZero(int: baseStats.attr + modifier(for: .Attractiveness)))
        case .Luck:
            return (baseValue: baseStats.luck, displayValue: cantGoBelowZero(int: baseStats.luck + modifier(for: .Luck)))
        case .MovementAllowance:
            return (baseValue: baseStats.ma, displayValue: cantGoBelowZero(int: baseStats.ma + modifier(for: .MovementAllowance)))
        case .Body:
            return (baseValue: baseStats.body, displayValue: cantGoBelowZero(int: baseStats.body + modifier(for: .Body)))
        case .Empathy:
            // TODO: Cyberpsychosis
            let empathy = value(for: .Humanity).displayValue / 10
            
            return (baseValue: baseStats.emp, displayValue: cantGoBelowZero(int: empathy < 0 ? 0 : empathy))
        case .Run:
            let runValue = value(for: .MovementAllowance).displayValue * 3
            return (baseValue: runValue, displayValue: cantGoBelowZero(int: runValue))
        case .Leap:
            let leapValue = value(for: .Run).displayValue / 4
            return (baseValue: leapValue, displayValue: cantGoBelowZero(int: leapValue))
        case .Lift:
            let liftValue = value(for: .Body).displayValue * 40
            return (baseValue: liftValue, displayValue: cantGoBelowZero(int: liftValue))
        case .Reputation:
            return (baseValue: baseStats.rep, displayValue: cantGoBelowZero(int: baseStats.rep + modifier(for: .Reputation)))
        case .Humanity:
            return (baseValue: baseHumanity, displayValue: cantGoBelowZero(int: baseHumanity - humanityLoss))
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
    ///   - role: The new player role
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
    
    func apply(damage: Int, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        guard CharacterValidator.validate(incomingDamage: damage, currentDamage: self.damage, completion: completion) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.damage += damage

            self.statModifiers.removeAll(where: { $0.damageRelated })
            
            let modifiers = Rules.Damage.statModifiers(forTotalDamage: self.damage, baseStats: self.baseStats)
            
            self.statModifiers.append(contentsOf: modifiers)
            
            completion(.success(.valid))

            NotificationCenter.default.post(name: .statsDidChange, object: nil)
            NotificationCenter.default.post(name: .damageDidChange, object: nil)
            
            self.saveCharacter()
        }
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
    
    private func cantGoBelowZero(int: Int) -> Int {
        if int <= 0 {
            return 0
        }
        
        return int
    }
    
    private func damageUpdate() {

    }
    
    /// Saves the character to disk.
    private func saveCharacter() {
        guard let JSONData = JSONFactory().encode(with: self) else { return }
        NotificationCenter.default.post(name: .saveToDiskRequested, object: JSONData)
    }
    
}
