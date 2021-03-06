//
//  BodyLocation.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/20/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

enum BodyLocation: String, CaseIterable, Codable, CheckboxConfigProviding {
    
    case Head, Torso, LeftArm, RightArm, LeftLeg, RightLeg

    func labelText() -> String {
        switch self {
        case .LeftArm: return "L. Arm"
        case .RightArm: return "R. Arm"
        case .LeftLeg: return "L. Leg"
        case .RightLeg: return "R. Leg"
        default: return rawValue
        }
    }
    
    func descriptiveText() -> String {
        switch self {
        case .Head, .Torso:
            return rawValue
        case .LeftArm:
            return BodyStrings.leftArm
        case .RightArm:
            return BodyStrings.rightArm
        case .LeftLeg:
            return BodyStrings.leftLeg
        case .RightLeg:
            return BodyStrings.rightLeg
        }
    }
    
    static func checkboxConfig() -> CheckboxConfig {
        let choices = [[BodyLocation.Head.labelText()],
                       [BodyLocation.RightArm.labelText(), BodyLocation.Torso.labelText(), BodyLocation.LeftArm.labelText()],
                       [BodyLocation.RightLeg.labelText(), BodyLocation.LeftLeg.labelText()]]
        return CheckboxConfig(choices: choices,
                              maxChoices: BodyLocation.allCases.count,
                              minChoices: 1,
                              selectedStates: [])
    }
    
    static func from(string: String) -> BodyLocation? {
        return BodyLocation.allCases.first(where: { $0.labelText() == string }) ?? BodyLocation(rawValue: string)
    }
    
}

/// A set of body locations that represent a single piece of armor
typealias ArmorPiece = [BodyLocation]

extension Array where Element == BodyLocation {
    
    /// Armor that covers the Head
    static var helmet: ArmorPiece {
        [.Head]
    }
    
    /// Armor that covers both legs
    static var pants: ArmorPiece {
        [.LeftLeg, .RightLeg]
    }
    
    /// Armor that covers the Torso and both arms
    static var jacket: ArmorPiece {
        [.LeftArm, .Torso, .RightArm]
    }
    
    /// Armor that covers the Torso only
    static var vest: ArmorPiece {
        [.Torso]
    }
    
    /// Armor that covers every body location
    static var fullBody: ArmorPiece {
        [.Head, .Torso, .LeftArm, .RightArm, .LeftLeg, .RightLeg]
    }
    
    func overlaps(_ armorPiece: ArmorPiece) -> Bool {
        for location in self {
            if armorPiece.contains(location) {
                return true
            }
        }
        
        return false
    }
    
}
