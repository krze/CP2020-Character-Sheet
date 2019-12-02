//
//  Wound.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/2/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Represents a wound taken on the individual.
struct Wound: Codable {
    
    /// The nature of the wound
    let traumaType: TraumaType
    
    /// The amount of damage as specified after rolling the dice, and potentially reducing for armor.
    let damageAmount: Int
    
    /// Where the wound is located
    let location: BodyLocation
    
    /// Calculates the total damage based on location variables. Use this instead of `damageAmount` to get the actual damage
    /// caused to the location.
    func totalDamage() -> Int {
        if traumaType != .CyberwareDamage && location == .Head {
            return damageAmount * Rules.Damage.headWoundMultiplier
        }
        
        return damageAmount
    }
    
    /// Specifies whether this wound is a mortal wound. Outside of the mortal track, particuarly traumatic wounds must be
    /// accompanied with a mortal check
    func isMortal() -> Bool {
        guard traumaType != .CyberwareDamage else { return false }
        
        return totalDamage() >= Rules.Damage.mortalWoundThreshold
    }
    
    /// Specifieds whether this wound is instantly fatal. This cannot be resisted with a Mortal check.
    func isFatal() -> Bool {
        return isMortal() && location == .Head
    }
}
