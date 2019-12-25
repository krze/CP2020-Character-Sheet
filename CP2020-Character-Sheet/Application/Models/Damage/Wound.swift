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
    let location: BodyLocation
    
    /// A unique ID created to ensure two wounds don't get mixed up
    let uniqueID: UUID = UUID()

    /// Specifies whether this wound is a mortal wound. Outside of the mortal track, particuarly traumatic wounds must be
    /// accompanied with a mortal check
    func isMortal() -> Bool {
        guard traumaType != .CyberwareDamage else { return false }
        
        return damageAmount >= Rules.Damage.mortalWoundThreshold
    }
    
    /// Specifies whether this wound is instantly fatal. This cannot be resisted with a Mortal check.
    func isFatal() -> Bool {
        return isMortal() && location == .Head
    }

    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(traumaType)
        hasher.combine(damageAmount)
        hasher.combine(location)
        hasher.combine(uniqueID)
    }

    static func == (lhs: Wound, rhs: Wound) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}
