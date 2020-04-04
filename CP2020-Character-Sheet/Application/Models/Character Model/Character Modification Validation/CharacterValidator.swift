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
    ///   - violationFound: Validation completion handler. Only gets called in this method if a violation occurs.
    static func validate(skillListing: SkillListing, completion violationFound: ValidatedCompletion) -> Bool {
        guard Rules.Skills.validPointRange.contains(skillListing.points) else {
            violationFound(.failure(Violation(ofType: .invalidSkillPointAmount, violators: [skillListing.skill.name])))
            return false
        }
        
        guard Rules.Skills.validIPPointRange.contains(skillListing.improvementPoints) else {
            violationFound(.failure(Violation(ofType: .invalidIPPointAmount, violators: [skillListing.skill.name])))
            return false
        }
        
        guard Rules.Skills.validMultiplierRange.contains(skillListing.skill.IPMultiplier) else {
            violationFound(.failure(Violation(ofType: .invalidIPMultiplier, violators: [String(skillListing.skill.IPMultiplier)])))
            return false
        }
        
        return true
    }
    
    /// Validates the new stats provided
    /// - Parameters:
    ///   - stats: Incoming stat values
    ///   - humanityLoss: Incoming humanity loss value
    ///   - violationFound: Validation completion handler. Only gets called in this method if a violation occurs.
    static func validate(baseStats stats: Stats, humanityLoss: Int, completion violationFound: ValidatedCompletion) -> Bool {
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
    
    /// Validates the incoming damage to ensure it can be applied
    /// - Parameters:
    ///   - incomingDamage: The damage amount incoming
    ///   - currentDamage: The current damage of the character
    ///   - violationFound: Validation completion handler. Only gets called in this method if a violation occurs.
    static func validate(incomingDamage: IncomingDamage, currentDamage: Int, completion violationFound: ValidatedCompletion) -> Bool {
        let maxPotentialIncomingDamage = incomingDamage.rollResult.reduce(0, { $0 + $1 })
        let (pendingCurrentDamage, didOverflow): (Int, Bool) = currentDamage.addingReportingOverflow(maxPotentialIncomingDamage)
        guard !didOverflow,
            pendingCurrentDamage >= 0,
            pendingCurrentDamage != currentDamage else {
            violationFound(.failure(Violation(ofType: .invalidNewDamageValue, violators: [String(maxPotentialIncomingDamage), String(currentDamage)])))
            return false
        }
        
        return true
    }
    
    /// Validates the armor being added to the Edgerunner
    /// - Parameters:
    ///   - newArmor: The new armor piece being added
    ///   - existingArmor: The armor already worn by the Edgerunner
    ///   - violationFound: Validation completion handler. Only gets called in this method if a violation occurs.
    static func validate(newArmor: Armor, existingArmor: [Armor], completion violationFound: ValidatedCompletion) -> Bool {
        
        guard newArmor.locations.count >= Rules.WornArmor.minimumLocationCount else {
            violationFound(.failure(Violation(ofType: .invalidArmorLocationsCount, violators: [newArmor.name])))
            return false
        }
        
        var proposedNewArmor = existingArmor
        proposedNewArmor.append(newArmor)
        
        let exceedMaxLayersLocations = Rules.WornArmor.locationsExceedMaxLayers(proposedNewArmor)
        
        if exceedMaxLayersLocations.count > 0 {
            let violators = exceedMaxLayersLocations.compactMap { (key, value) -> String in
                return "\(key.labelText()): \(value)"
            }
            
            violationFound(.failure(Violation(ofType: .maximumArmorLayersExceeded, violators: violators)))
            return false
        }
        
        let exceedsMaxHardArmorLocations = Rules.WornArmor.locationExceedsMaxHardArmor(proposedNewArmor)
        
        if exceedsMaxHardArmorLocations.count > 0 {
            let violators = exceedsMaxHardArmorLocations.compactMap { (key, value) -> String in
                return "\(key.labelText()): \(value)"
            }
            
            violationFound(.failure(Violation(ofType: .maximumHardArmorExceeded, violators: violators)))
            return false
        }
        
        return true
    }
}
