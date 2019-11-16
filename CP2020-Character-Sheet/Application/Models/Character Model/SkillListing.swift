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
    
    /// Number of points alloted to the skill by the player
    private(set) var points: Int
    
    /// The number of IP in the skill
    private(set) var improvementPoints: Int
    
    /// The number of IP required to level up
    private var nextLevelIP: Int {
        guard skill.IPMultiplier > 0  else { return Int.max } // Protection against a loop
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
    private(set) var statModifier: Int
    
    /// Returns the value of the skill added to the skill check roll
    var skillRollValue: Int {
        return points + modifier + statModifier
    }
    
    var starred: Bool = false
    
    init(skill: Skill, points: Int, improvementPoints: Int = 0, modifier: Int, statModifier: Int?) {
        self.skill = skill
        self.points = points
        self.modifier = modifier
        self.statModifier = statModifier ?? 0
        self.improvementPoints = improvementPoints
        
        starred = skill.isSpecialAbility
        updateImprovementPoints()
    }
    
    /// Updates the raw point value
    ///
    /// - Parameter points: The new point value for the skill
    func update(points: Int) {
        self.points = points
    }
    
    /// Updates the modifier point value
    ///
    /// - Parameter points: The new point value for the modifier
    func update(modifierPoints: Int) {
        self.modifier = modifierPoints
    }
    
    /// Updates the stat modifier point value
    ///
    /// - Parameter points: The new point value for the stat modifier
    func update(statModifierPoints: Int) {
        self.statModifier = statModifierPoints
    }
    
    /// Adds the points to the existing IP value
    ///
    /// - Parameter newPoints: IP to add to the existing IP
    func add(improvementPoints newPoints: Int) {
        improvementPoints += newPoints
        updateImprovementPoints()
    }
    
    private func updateImprovementPoints() {
        var remainingImprovementPoints = improvementPoints
        
        while remainingImprovementPoints >= nextLevelIP {
            remainingImprovementPoints = remainingImprovementPoints - nextLevelIP
            points += 1
        }
        
        improvementPoints = remainingImprovementPoints
    }
    
    func displayName() -> String {
        guard let nameExtension = skill.nameExtension else {
            return skill.name
        }
        return "\(skill.name): \(nameExtension)"
    }
    
    enum CodingKeys: String, CodingKey {
        case statModifier = "stat_modifier"
        case improvementPoints = "ip"
        case skill, points, modifier
    }
}
