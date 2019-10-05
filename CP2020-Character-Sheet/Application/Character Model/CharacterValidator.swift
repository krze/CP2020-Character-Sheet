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
            violationFound(.failure(Violation(ofType: .invalidSkillPointAmount, violators: [skillListing.skill.name])))
            return false
        }
        
        guard Rules.Skills.validIPPointRange.contains(skillListing.improvementPoints) else {
            violationFound(.failure(Violation(ofType: .invalidIPPointAmount, violators: [skillListing.skill.name])))
            return false
        }
        
        return true
    }
    
    static func validate(baseStats stats: Stats, humanityLoss: Int, completion violationFound: (ValidatedEditorResult) -> Void) -> Bool {
        var violations = [Stat: Int]()
        
        violations[.Intelligence] = Rules.Stats.validPointRange.contains(stats.int) ? nil : stats.int
        violations[.Empathy] = Rules.Stats.validPointRange.contains(stats.emp) ? nil : stats.int
        violations[.Reflex] = Rules.Stats.validPointRange.contains(stats.ref) ? nil : stats.int
        violations[.Cool] = Rules.Stats.validPointRange.contains(stats.cool) ? nil : stats.int
        violations[.Tech] = Rules.Stats.validPointRange.contains(stats.tech) ? nil : stats.int
        violations[.Attractiveness] = Rules.Stats.validPointRange.contains(stats.attr) ? nil : stats.int
        violations[.Luck] = Rules.Stats.validPointRange.contains(stats.luck) ? nil : stats.int
        violations[.Body] = Rules.Stats.validPointRange.contains(stats.body) ? nil : stats.int
        violations[.MovementAllowance] = Rules.Stats.validPointRange.contains(stats.ma) ? nil : stats.int
        violations[.Reputation] = Rules.Stats.validPointRange.contains(stats.rep) ? nil : stats.int

        guard violations.isEmpty else {
            let invalidStats = violations.keys.map { "\($0.plainText()) (\($0.identifier()))" }
            let violation = Violation(ofType: .invalidStatPointAmount, violators: invalidStats)
            violationFound(.failure(violation))
            return false
        }
        
        guard Rules.Stats.checkHumanityLoss(againstBaseEmpathyValue: stats.emp, humanityLoss: humanityLoss) else {
            violationFound(.failure(Violation(ofType: .invalidHumanityLoss, violators: [String(stats.emp * 10)])))
            return false
        }
        
        return true
    }
    
    static func validate(incomingDamage: Int, currentDamage: Int, completion violationFound: (ValidatedEditorResult) -> Void) -> Bool {
        let (pendingCurrentDamage, didOverflow): (Int, Bool) = currentDamage.addingReportingOverflow(incomingDamage)
        guard !didOverflow,
            pendingCurrentDamage >= 0,
            pendingCurrentDamage <= Rules.Damage.maxDamagePoints,
            pendingCurrentDamage != currentDamage else {
            violationFound(.failure(Violation(ofType: .invalidNewDamageValue, violators: [String(incomingDamage), String(currentDamage)])))
            return false
        }

        return true
    }
}
