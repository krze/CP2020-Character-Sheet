//
//  SkillStrings.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/15/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Strings used in the skill editor view
struct SkillStrings {
    static let skill = "Skill"
    
    static let skillName = "Name"
    static let skillNameHelpText = "The name of the skill."
    
    static let skillNameExtension = "Optional Extension"
    static let skillNameExtensionHelpText = "Optional extension to the skill name (i.e. the 'English' in 'Language: English'"
    
    static let associatedStat = "Associated Stat"
    static let associatedStatHelpText = "The player stat associated with this skill. The points in the stat are added to the total points for the skill."
    
    static let pointsAssigned = "Points Assigned By Player"
    static let modifierPoints = "Modifier Points"
    static let totalPoints = "Total Points"
    
    static let improvementPoints = "Improvement Points"
    static let improvementPointsHelpText = "The IP accrued for usage of this skill."
    
    static let IPMultiplier = "IP Multiplier"
    static let IPMultiplierHelpText = "An additional multiplier to the number of IP required to increase the number of skill points."
    
    static let description = "Description"
    static let descriptionHelpText = "Describes the valid usage of the skill."
    
    static let favorite = "Highlighted Skill"
    static let hideSkill = "Hide Skill"
}
