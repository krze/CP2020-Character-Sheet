//
//  CharacterValidator.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 8/22/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

struct CharacterValidator {
    
    /// Validates a skill listing. Will call the completion if it fails, otherwise returns true.
    ///
    /// - Parameters:
    ///   - skillListing: The skill listing to validate.
    ///   - completion: Validation completion handler
    static func validate(skillListing: SkillListing, completion violationFound: (ValidatedEditorResult) -> Void) -> Bool {
        guard Rules.Skills.validPointRange.contains(skillListing.points) else {
            violationFound(.failure(.invalidSkillPointAmount))
            return false
        }
        
        guard Rules.Skills.validIPPointRange.contains(skillListing.improvementPoints) else {
            violationFound(.failure(.invalidIPPointAmount))
            return false
        }
        
        return true
    }
    
    static func validate(baseStats stats: Stats, humanityLoss: Int, completion violationFound: (ValidatedEditorResult) -> Void) -> Bool {
        guard Rules.Stats.validPointRange.contains(stats.int),
            Rules.Stats.validPointRange.contains(stats.emp),
            Rules.Stats.validPointRange.contains(stats.ref),
            Rules.Stats.validPointRange.contains(stats.cool),
            Rules.Stats.validPointRange.contains(stats.tech),
            Rules.Stats.validPointRange.contains(stats.attr),
            Rules.Stats.validPointRange.contains(stats.luck),
            Rules.Stats.validPointRange.contains(stats.body),
            Rules.Stats.validPointRange.contains(stats.ma),
            Rules.Stats.validPointRange.contains(stats.rep) else {
                violationFound(.failure(.invalidStatPointAmount))
                return false
        }
        
        guard Rules.Stats.checkHumanityLoss(againstBaseEmpathyValue: stats.emp, humanityLoss: humanityLoss) else {
            violationFound(.failure(.invalidHumanityLoss))
            return false
        }
        
        return true
    }
}
