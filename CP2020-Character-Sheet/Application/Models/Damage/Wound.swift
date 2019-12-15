//
//  Wound.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/2/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Represents a wound taken on the individual.
struct Wound: Codable, Hashable {
    
    /// The nature of the wound
    let traumaType: TraumaType
    
    /// The amount of damage as specified after rolling the dice, and potentially reducing for armor.
    let damageAmount: Int
    
    /// Where the wound is located
    let locations: [BodyLocation]
    
    /// A unique ID created to ensure two wounds don't get mixed up
    let uniqueID: UUID = UUID()
    
    /// Calculates the total damage based on location variables. Use this instead of `damageAmount` to get the actual damage
    /// caused to the location.
    func totalDamage() -> Int {
        guard !isMultiLocation() else { return damageAmount }
        
        if traumaType != .CyberwareDamage && locations.contains(.Head) {
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
    
    /// Specifies whether this wound is instantly fatal. This cannot be resisted with a Mortal check.
    func isFatal() -> Bool {
        return isMortal() && locations.contains(.Head)
    }
    
    /// Specifies if the wound covers multiple locations.
    func isMultiLocation() -> Bool {
        return locations.count > 1
    }
    
    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(traumaType)
        hasher.combine(damageAmount)
        hasher.combine(locations)
        hasher.combine(uniqueID)
    }

    static func == (lhs: Wound, rhs: Wound) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}
