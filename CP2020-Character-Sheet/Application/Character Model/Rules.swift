//
//  Rules.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 8/22/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// A set of rules for ensuring a character is valid.
struct Rules {
    
    struct Skills {
        /// The range of valid points a skill can be
        static let validPointRange = 0...10
        
        /// The range of valid points IP can be
        static let validIPPointRange = 0...Int.max
    }
    
    struct Stats {
        /// The range of valid points a stat can be
        static let validPointRange = 1...10
        
        /// Validates humanity loss is a valid amount
        ///
        /// - Parameters:
        ///   - empathy: Base empahty value
        ///   - humanityLoss: The amount of humanity loss
        /// - Returns: True if this is a valid amount of humanity loss
        static func checkHumanityLoss(againstBaseEmpathyValue empathy: Int, humanityLoss: Int) -> Bool {
            let maxHumanity = empathy*10
            
            return maxHumanity - abs(humanityLoss) >= 0
        }
    }
    
    struct Damage {
        
        static let maxDamagePoints = 40
        static let pointsPerSection = 4
        
        static func wound(forTotalDamage totalDamage: Int) -> WoundType? {
            switch totalDamage {
            case 0: return nil
            case 1...4: return .Light
            case 5...8: return .Serious
            case 9...12: return .Critical
            default: return .Mortal
            }
        }
        
        static func mortalValue(forTotalDamage totalDamage: Int) -> Int? {
            switch totalDamage {
            case 13...16: return 0
            case 17...20: return 1
            case 21...24: return 2
            case 25...28: return 3
            case 29...32: return 4
            case 33...36: return 5
            case 37...40: return 6
            default: return nil
            }
        }
        
        static func stunValue(forTotalDamage totalDamage: Int) -> Int? {
            switch totalDamage {
            case 1...4: return 0
            case 5...8: return 1
            case 9...12: return 2
            case 13...16: return 3
            case 17...20: return 4
            case 21...24: return 5
            case 25...28: return 6
            case 29...32: return 7
            case 33...36: return 8
            case 37...40: return 9
            default: return nil
            }
        }
    }
}

enum Violation: Error {
    case invalidSkillPointAmount, invalidIPPointAmount, invalidStatPointAmount, invalidHumanityLoss
    
    func title() -> String {
        switch self {
        case .invalidSkillPointAmount:
            return "Skill Points Invalid!"
        case .invalidIPPointAmount:
            return "Improvement Points Invalid!"
        case .invalidStatPointAmount:
            return "Stat Points Invalid!"
        case .invalidHumanityLoss:
            return "Humanity Loss Invalid!"
        }
    }
    
    func helpText() -> String {
        switch self {
        case .invalidSkillPointAmount:
            return "Skill points must be an integer in the range of 1 to 10"
        case .invalidIPPointAmount:
            return "IP must be a positive integer."
        case .invalidStatPointAmount:
            return "Stat points must be an integer in the range of 0 to 10"
        case .invalidHumanityLoss:
            return "Humanity deficit cannot go lower than the amount of EMP you have x10."
        }
    }
}
