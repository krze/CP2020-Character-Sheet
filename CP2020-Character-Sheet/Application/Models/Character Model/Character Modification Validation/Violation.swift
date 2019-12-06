//
//  Violation.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/5/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

struct Violation: Error {
    
    let ofType: ViolationType
    let violators: [String]
    enum ViolationType {
        case invalidSkillPointAmount, invalidIPPointAmount, invalidIPMultiplier, invalidStatPointAmount, invalidHumanityLoss, invalidNewDamageValue, invalidArmorLocationsCount, maximumArmorLayersExceeded, maximumHardArmorExceeded
    }
    
    func title() -> String {
        switch self.ofType {
        case .invalidSkillPointAmount:
            return "Skill Points Invalid!"
        case .invalidIPPointAmount:
            return "Improvement Points Invalid!"
        case .invalidStatPointAmount:
            return "Stat Points Invalid!"
        case .invalidHumanityLoss:
            return "Humanity Loss Invalid!"
        case .invalidNewDamageValue:
            return "Damage Change Invalid!"
        case .invalidIPMultiplier:
            return "IP Multiplier Invalid!"
        case .invalidArmorLocationsCount:
            return "Armor Location Count Invalid!"
        case .maximumArmorLayersExceeded:
            return "Maximum Armor Layers Exceeded!"
        case .maximumHardArmorExceeded:
            return "Maximum Hard Armor Amount Exceeded"
        }
    }
    
    func helpText() -> String {
        switch self.ofType {
        case .invalidSkillPointAmount:
            return "Skill points must be an integer in the range of 1 to 10"
        case .invalidIPPointAmount:
            return "IP must be a positive integer."
        case .invalidStatPointAmount:
            return "The following stat points must be an integer in the range of 1 to 10:\n\(violators.joined(separator: "\n"))"
        case .invalidHumanityLoss:
            return "Humanity deficit cannot go exceed \(violators.first ?? "your base empathy x 10")."
        case .invalidNewDamageValue:
            return "Damage cannot exceed 40 or go below 0. \(violators.first ?? "Incoming") damage cannot be applied to \(violators.last ?? "your current") damage."
        case .invalidIPMultiplier:
            return "IP multiplier must be a whole number greater than zero. \(violators.first ?? "The value you entered") is not a valid multiplier."
        case .invalidArmorLocationsCount:
            let count = Rules.WornArmor.minimumLocationCount
            return "\(violators.first ?? "The armor you created") must cover at least \(count) body location\(count > 1 ? "s" : "")."
        case .maximumArmorLayersExceeded:
            let maxCount = Rules.WornArmor.maxLayersPerLocation
            let violatingLocations = violators.joined(separator: "\n")
            
            return "The following locations have exceeded \(maxCount) layer\(maxCount > 1 ? "s" : "") of armor:\n\(violatingLocations)"
        case .maximumHardArmorExceeded:
            let maxCount = Rules.WornArmor.maxHardArmorPerLocation
            let violatingLocations = violators.joined(separator: "\n")
            return "The following locations have exceeded \(maxCount) hard armor piece\(maxCount > 1 ? "s" : ""):\n\(violatingLocations)"
        }
    }
}
