//
//  SkillListing.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Represents the listing of a skill as it is known to the character
final class SkillListing: Codable {
    
    /// The skill tied to the listing
    let skill: Skill
    
    /// Category for display purposes inside of a tableview. This will be the stat associated with the skill.
    let category: String?
    
    /// Number of points alloted to the skill by the player
    private(set) var points: Int
    
    /// The number of IP in the skill
    private(set) var improvementPoints: Int
    
    /// The number of IP required to level up
    private var nextLevelIP: Int {
        let base = 10
        
        switch points {
        case 0:
            return base * skill.IPMultiplier
        default:
            return base * points * skill.IPMultiplier
        }
    }
    
    /// The number of points that modify this score. This does not include the linked stat.
    /// This field is intended for positive or negative effects (i.e. temporary states)
    private(set) var modifier: Int
    
    /// The modifier from the linked stat, if any
    private(set) var statModifier: Int // TODO: This will be stale from the JSON if stat points change.
    
    /// Returns the value of the skill added to the skill check roll
    var skillRollValue: Int {
        return points + modifier + statModifier
    }
    
    init(skill: Skill, points: Int, modifier: Int, statModifier: Int?) {
        self.skill = skill
        self.points = points
        self.modifier = modifier
        // TODO: Make stat modifier a computed property based on a stat lookup
        self.statModifier = statModifier ?? 0
        self.improvementPoints = 0
        
        category = skill.isSpecialAbility ? "Special Ability" : skill.linkedStat?.rawValue
    }
    
    /// Updates the raw point value
    ///
    /// - Parameter points: The new point value for the skill
    func update(points: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.points = points
            
            NotificationCenter.default.post(name: .skillPointsDidChange, object: self)
        }

    }
    
    /// Updates the modifier point value
    ///
    /// - Parameter points: The new point value for the modifier
    func update(modifierPoints: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.modifier = modifierPoints
            
            NotificationCenter.default.post(name: .skillPointModifierDidChange, object: self)
        }
        
    }
    
    /// Updates the stat modifier point value
    ///
    /// - Parameter points: The new point value for the stat modifier
    func update(statModifierPoints: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.statModifier = statModifierPoints
            
            // This does not fire off a notification center event as this will almost always be a bulk
            // update performed by the Edgerunner class. Stats are supposed to be immutable according to
            // the game rules, so changing this modifier will be a modification at the character level.
        }
    }
    
    /// Adds the points to the existing IP value
    ///
    /// - Parameter newPoints: IP to add to the existing IP
    func add(improvementPoints newPoints: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.improvementPoints += newPoints
            
            NotificationCenter.default.post(name: .improvementPointsAdded, object: self)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case statModifier = "stat_modifier"
        case improvementPoints = "ip"
        case skill, category, points, modifier
    }
}
