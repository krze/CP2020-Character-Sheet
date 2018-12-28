//
//  Edgerunner.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/23/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// The model for the player character
final class Edgerunner: Codable, SkillManager {
    
    /// The player stats assigned at creation. These stats are immutable according to game rules; you must
    /// update the stat via set(stats: Stats). These are the raw, base stats. Use value(for: Stat) to retrieve
    /// the calculated stat values includng pentalties
    private(set) var baseStats: Stats
    
    /// Character role, aka "Class"
    private(set) var role: Role
    
    /// Skills belonging to a character. These are skills that the character has invested in, not all skills.
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
    private var humanityCost: Int
    
    /// Creates a character with the input provided. Skills are not assigned via this initalizer, and
    /// must be set by using `add(skill: SkillListing)`. This initializer is intended to be used by
    /// first-time character creation. For the most part, this class will be created from JSON.
    ///
    /// - Parameters:
    ///   - baseStats: Character stats object representing the base stat values
    ///   - role: The role of the character
    ///   - humanityCost: The humanity cost from cyberware (NOTE: This will be a computed property when cyberware is supported)
    init(baseStats: Stats, role: Role, humanityCost: Int) {
        self.baseStats = baseStats
        self.role = role
        self.humanityCost = humanityCost
        damage = 0
        skills = [SkillListing]()
    }
    
    /// Retrieves the value for the stat requested
    ///
    /// - Parameter stat: The stat you want
    /// - Returns: The value for the requested stat
    func value(for stat: Stat) -> Int {
        switch stat {
        case .Intelligence:
            return baseStats.int
        case .Reflex:
            return baseStats.ref - reflexPentalty
        case .Tech:
            return baseStats.tech
        case .Cool:
            return baseStats.cool
        case .Attractiveness:
            return baseStats.attr
        case .Luck:
            return baseStats.luck
        case .MovementAllowance:
            return baseStats.ma
        case .Body:
            return baseStats.body
        case .Empathy:
            // TODO: Cyberpsychosis
            let empathy = value(for: .Humanity) / 10
            
            return empathy > 0 ? empathy : 1
        case .Run:
            return baseStats.ma * 3
        case .Leap:
            return value(for: .Run) / 4
        case .Lift:
            return value(for: .Body) * 40
        case .Reputation:
            return baseStats.rep
        case .Humanity:
            return baseHumanity - humanityCost
        }
    }
    
    /// Adds the skill to the character, overwriting if the skill already exists.
    ///
    /// - Parameter newSkill: The new skill to add.
    func add(skill newSkill: SkillListing) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let existingSkill = self.skills.first(where: { $0.skill == newSkill.skill }) {
                existingSkill.update(points: newSkill.points)
            } else {
                self.skills.append(newSkill)
            }
            
            NotificationCenter.default.post(name: .newSkillAdded, object: newSkill)
        }
    }
    
    /// Updates the stats. This should only be called if editing the character.
    /// Stats are immutable during normal gameplay.
    ///
    /// - Parameter baseStats: The new Stats object
    func set(baseStats: Stats) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.baseStats = baseStats
            
            self.updateStatModifiers()
            
            NotificationCenter.default.post(name: .statsDidChange, object: nil)
        }
    }
    
    /// Updates the character role. Call this when editing the character, otherwise
    /// this value should be immutable during normal gameplay.
    ///
    /// - Parameter role: The new player role
    func set(role: Role) {
        self.role = role
    }
    
    /// Updates the stat modifiers for each skill
    private func updateStatModifiers() {
        for skillListing in skills {
            guard let stat = skillListing.skill.linkedStat,
                skillListing.statModifier != value(for: stat) else {
                continue
            }
            
            skillListing.update(statModifierPoints: value(for: stat))
        }
    }
    
    /// Saves the character to disk.
    private func save() {
        // TODO: Persistence object for managing saves
    }
}
