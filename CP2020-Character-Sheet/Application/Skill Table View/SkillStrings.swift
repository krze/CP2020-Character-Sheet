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
    
    static let skillNameHelpText = "The name of the skill."
    
    static let skillNameExtensionHelpText = "Optional extension to the skill name (i.e. the 'English' in 'Language: English'"
    
    static let associatedStatHelpText = "The player stat associated with this skill. The points in the stat are added to the total points for the skill."
    
    static let pointsAssignedHelpText = "Points assigned by player"
    static let modifierPointsHelpText = "Modifier points due to equipment, or emphemeral states."
    
    static let improvementPoints = "IP"
    static let improvementPointsHelpText = "The Improvement Points accrued for usage of this skill."
    
    static let IPMultiplier = "IP Multiplier"
    static let IPMultiplierHelpText = "An additional multiplier to the number of IP required to increase the number of skill points."
    
    static let descriptionHelpText = "Describes the valid usage of the skill."
    
    static let favorite = "Highlighted Skill"
    static let hideSkill = "Hide Skill"
}
