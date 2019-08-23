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
