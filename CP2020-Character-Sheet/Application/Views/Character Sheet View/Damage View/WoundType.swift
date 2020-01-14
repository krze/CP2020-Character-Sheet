//
//  WoundType.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Categories of Wounds.
///
/// - Light: Light wound
/// - Serious: Serious wound
/// - Critical: Critical wound
/// - Mortal: Mortal Wound
enum WoundType: String, CaseIterable {
    case Light, Serious, Critical, Mortal
    
    func saveRollTypes() -> [SaveRollType] {
        switch self {
        case .Mortal:
            return [.Mortal, .Stun]
        default:
            return [.Stun]
        }
    }
}

/// Categories of Save Roll effects.
///
/// - Stun: Stun effect
enum SaveRollType: String, Codable, CaseIterable {
    case Stun, Mortal
}

/// Categories of Damage types
enum TraumaType: String, CaseIterable, Codable {
    case Blunt, Piercing, Burn, CyberwareDamage
    
    func abbreviation() -> String {
        switch self {
        case .Burn:
            return "BURN"
        case .Blunt:
            return "BLNT"
        case .Piercing:
            return "PRCE"
        case .CyberwareDamage:
            return "CYBR"
        }
    }
    
    func identifier() -> String {
        switch self {
        case .CyberwareDamage:
            return "Cyberware Damage"
        default:
            return rawValue
        }
    }
}
