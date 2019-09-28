//
//  Edgerunner.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/23/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

typealias EditableModel = CharacterDescriptionModel & StatsModel & SkillModel

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
    var damage: Int
    
    /// In the case where the character is healing, there will be a reflex penalty.
    /// This is not utilized at the moment, but will be in the future.
    private var reflexPentalty: Int = 0
    
    private var baseHumanity: Int {
        return baseStats.emp * 10
    }
    
    /// The humanity deficit incurred by Cyberware
    private(set) var humanityLoss: Int
    
    /// To be used in the future for when you can spend luck points.
    private var spentLuck: Int = 0
    
    // To be used in the future for when you have a MA penalty for armor. Will be calculated most likely.
    private var movementAllowancePenalty: Int = 0
    
    /// Creates a character with the input provided. Skills are not assigned via this initalizer, and
    /// must be set by using `add(skill: SkillListing)`. This initializer is intended to be used by
    /// first-time character creation. For the most part, this class will be created from JSON.
    ///
    /// - Parameters:
    ///   - baseStats: Character stats object representing the base stat values
    ///   - role: The role of the character
    ///   - humanityLoss: The humanity loss from cyberware (NOTE: This will be a computed property when cyberware is supported)
    init(baseStats: Stats, role: Role, humanityLoss: Int, skills: [Skill]) {
        self.baseStats = baseStats
        self.role = role
        self.humanityLoss = humanityLoss
        damage = 0
        name = ""
        handle = ""
        
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
            return (baseValue: baseStats.int, displayValue: baseStats.int)
        case .Reflex:
            return (baseValue: baseStats.ref, displayValue: baseStats.ref - reflexPentalty)
        case .Tech:
            return (baseValue: baseStats.tech, displayValue: baseStats.tech)
        case .Cool:
            return (baseValue: baseStats.cool, displayValue: baseStats.cool)
        case .Attractiveness:
            return (baseValue: baseStats.attr, displayValue: baseStats.attr)
        case .Luck:
            return (baseValue: baseStats.luck, displayValue: baseStats.luck - spentLuck)
        case .MovementAllowance:
            return (baseValue: baseStats.ma, displayValue: baseStats.ma - movementAllowancePenalty)
        case .Body:
            return (baseValue: baseStats.body, displayValue: baseStats.body)
        case .Empathy:
            // TODO: Cyberpsychosis
            let empathy = value(for: .Humanity).displayValue / 10
            
            return (baseValue: baseStats.emp, displayValue: empathy < 0 ? 0 : empathy)
        case .Run:
            let runValue = value(for: .MovementAllowance).displayValue * 3
            return (baseValue: runValue, displayValue: runValue)
        case .Leap:
            let leapValue = value(for: .Run).displayValue / 4
            return (baseValue: leapValue, displayValue: leapValue)
        case .Lift:
            let liftValue = value(for: .Body).displayValue * 40
            return (baseValue: liftValue, displayValue: liftValue)
        case .Reputation:
            return (baseValue: baseStats.rep, displayValue: baseStats.rep)
        case .Humanity:
            return (baseValue: baseHumanity, displayValue: baseHumanity - humanityLoss)
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
            
            if let existingSkill = self.skills.first(where: { $0.skill == newSkill.skill }) {
                existingSkill.update(points: newSkill.points)
            } else {
                self.skills.append(newSkill)
            }
            
            completion(.success(.valid))
            NotificationCenter.default.post(name: .newSkillAdded, object: newSkill)
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
            self.humanityLoss = humanityLoss
            self.updateStatModifiers()
            
            completion(.success(.valid))
            NotificationCenter.default.post(name: .statsDidChange, object: nil)
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
        }
    }
    
    func set(name: String, handle: String, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        DispatchQueue.main.async {
            self.name = name
            self.handle = handle
            completion(.success(.valid))
            NotificationCenter.default.post(name: .nameAndHandleDidChange, object: nil)
        }
    }
    
    /// Updates the stat modifiers for each skill
    private func updateStatModifiers() {
        for skillListing in skills {
            guard let stat = skillListing.skill.linkedStat,
                skillListing.statModifier != value(for: stat).displayValue else {
                continue
            }
            
            skillListing.update(statModifierPoints: value(for: stat).displayValue)
        }
    }
    
    /// Saves the character to disk.
    private func save() {
        guard let JSONData = JSONFactory().encode(with: self) else { return }
        NotificationCenter.default.post(name: .saveToDiskRequested, object: JSONData)
        
        // NEXT: Persistence object for managing saves
    }
}
