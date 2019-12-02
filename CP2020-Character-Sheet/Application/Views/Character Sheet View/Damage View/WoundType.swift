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
}

/// Categories of Stun effects.
///
/// - Stun: Stun effect
enum StunType: String, CaseIterable {
    case Stun
}

/// Categories of Damage types
enum TraumaType: String, CaseIterable, Codable {
    case Blunt, Piercing, Burn, CyberwareDamage
    
    func abbreviation() -> String {
        switch self {
        case .Burn:
            return "BRN"
        case .Blunt:
            return "BLT"
        case .Piercing:
            return "PRC"
        case .CyberwareDamage:
            return "CYB"
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
