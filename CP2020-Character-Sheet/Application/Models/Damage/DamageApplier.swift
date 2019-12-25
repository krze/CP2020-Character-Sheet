//
//  DamageApplier.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/2/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Contains methods that help apply damage to the Edgerunner.
struct DamageHelper {
    
    /// Applies damage to the Edgerunner. Any damage that exceeds the Edgerunner's maximum damage will be ignored.
    /// Returns any wounds that would be sustained by the edgerunner.
    /// sustained that would not be protected by armor.
    /// - Parameters:
    ///   - edgerunner: The unlucky Edgerunner being attacked
    ///   - incomingDamage: The Incoming Damage
    static func applyArmorDamage(to edgerunner: ArmorModel, incomingDamage: IncomingDamage) -> [Wound] {
        let damageType = incomingDamage.damageType
        let locations = incomingDamage.hitLocations
        var damages = [DamageRollResult]()
        
        incomingDamage.rollResult.forEach { rollResult in
            // Verify there's a location, or else pick a random one
            let locations = locations.isEmpty ? [Rules.Damage.randomBodyLocation()] : locations
            damages.append(DamageRollResult(locations: locations, amount: rollResult, type: damageType))
        }
        
        var wounds = [Wound]()
        
        if !damages.isEmpty {
            edgerunner.equippedArmor.applyDamages(damages, coverSP: incomingDamage.coverSP) { leftoverDamage, locations, damageType in
                var traumaTypes = Rules.Damage.traumaTypes(for: damageType)
                let leftoverDamage = Rules.Damage.effectiveDamage(of: damageType, amount: leftoverDamage)
                
                // NEXT: Verify how much damage explosive damage gets proportionally
                
                if traumaTypes.count > 1 {
                    let amountPerWound = leftoverDamage / traumaTypes.count
                    let remainder = leftoverDamage % traumaTypes.count

                    while traumaTypes.count > 0 {
                        let thisType = traumaTypes.removeFirst()
                        let amount = traumaTypes.isEmpty ? amountPerWound + remainder : amountPerWound

                         wounds.append(Wound(traumaType: thisType, damageAmount: amount, locations: locations))
                    }
                }
                else {
                    if let traumaType = traumaTypes.first {
                        wounds.append(Wound(traumaType: traumaType, damageAmount: leftoverDamage, locations: locations))
                    }
                }
            }
        }
        
        return wounds
    }
    
}
