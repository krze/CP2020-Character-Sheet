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
    
    static let skillNameHelpText = "The name of the skill. A colon is used to specify the focus of a skill, if it has one (i.e. 'Language: English' to specify a language)."
    
    static let associatedStatHelpText = "The Edgerunner stat associated with this skill. The points in the stat are added to the total points for the skill."
    
    static let pointsAssignedHelpText = "Points assigned by Edgerunner"
    static let modifierPointsHelpText = "Modifier points due to equipment, or emphemeral states."
    
    static let improvementPoints = "IP"
    static let improvementPointsHelpText = "The Improvement Points accrued for usage of this skill."
    
    static let IPMultiplier = "IP Multiplier"
    static let IPMultiplierHelpText = "An additional multiplier to the number of IP required to increase the number of skill points."
    
    static let descriptionHelpText = "Describes the valid usage of the skill."
    
    static let modifiesSkill = "Modifies Skill"
    static let modifiesSkillHelpText = "A skill that is modified by adding this skill's points to the specified skill. (i.e. Comabt Sense boosts Awareness/Notice"
        
    static let favorite = "Highlighted Skill"
    static let hideSkill = "Hide Skill"
    
    static let searchSkills = "Search Skills"
    
    static let noAssociatedStat = "No Associated Stat"
}
