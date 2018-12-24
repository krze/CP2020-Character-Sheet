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
    
    /// Immutable player stats. This is maintained by the Edgerunner, and you must
    /// update the stat via set(stats: Stats)
    private(set) var stats: Stats
    
    /// Character role, aka "Class"
    private(set) var role: Role
    
    /// Skills belonging to a character. These are skills that the character has invested in, not all skills.
    private(set) var taggedSkills: [SkillListing]
    
    /// Damage on the player
    var damage: Int
    
    private var baseHumanity: Int {
        return stats.emp * 10
    }
    
    /// The humanity deficit incurred by Cyberware
    private var humanityCost: Int
    
    /// Creates a character with the input provided. Skills are not assigned via this initalizer, and
    /// must be set by using `add(skill: SkillListing)`. This initializer is intended to be used by
    /// first-time character creation. For the most part, this class will be created from JSON.
    ///
    /// - Parameters:
    ///   - stats: Character stats objet
    ///   - role: The role of the character
    ///   - humanityCost: The humanity cost from cyberware (NOTE: This will be a computed property when cyberware is supported)
    init(stats: Stats, role: Role, humanityCost: Int) {
        self.stats = stats
        self.role = role
        self.humanityCost = humanityCost
        damage = 0
        taggedSkills = [SkillListing]()
    }
    
    /// Retrieves the value for the stat requested
    ///
    /// - Parameter stat: The stat you want
    /// - Returns: The value for the requested stat
    func value(for stat: Stat) -> Int {
        switch stat {
        case .Intelligence:
            return stats.int
        case .Reflex:
            return stats.ref
        case .Tech:
            return stats.tech
        case .Cool:
            return stats.cool
        case .Attractiveness:
            return stats.attr
        case .Luck:
            return stats.luck
        case .MovementAllowance:
            return stats.ma
        case .Body:
            return stats.body
        case .Empathy:
            // TODO: Cyberpsychosis
            let empathy = value(for: .Humanity) / 10
            
            return empathy > 0 ? empathy : 1
        case .Run:
            return stats.ma * 3
        case .Leap:
            return value(for: .Run) / 4
        case .Lift:
            return value(for: .Body) * 40
        case .Reputation:
            return stats.rep
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
            
            self.taggedSkills.removeAll(where: { skillListing in
                return skillListing == newSkill
            })
            
            self.taggedSkills.append(newSkill)
            
            NotificationCenter.default.post(name: .newSkillAdded, object: newSkill)
        }
    }
    
    /// Updates the stats. This should only be called if editing the character.
    /// Stats are immutable during normal gameplay.
    ///
    /// - Parameter stats: The new stats object
    func set(stats: Stats) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.stats = stats

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
    
    /// Saves the character to disk.
    private func save() {
        // TODO: Persistence object for managing saves
    }
}
