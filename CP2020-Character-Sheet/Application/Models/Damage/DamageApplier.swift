//
//  DamageApplier.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/2/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Contains methods that help apply damage to the Edgerunner.
struct DamageApplier {
    
    /// Applies damage to the Edgerunner. Any damage that exceeds the Edgerunner's maximum damage will be ignored. Returns any wounds
    /// sustained that would not be protected by armor.
    /// - Parameters:
    ///   - edgerunner: The unlucky Edgerunner being attacked
    ///   - incomingDamage: The Incoming Damage
    static func applyArmorDamage(to edgerunner: ArmorModel, incomingDamage: IncomingDamage) -> [Wound] {
        let damageType = incomingDamage.damageType
        let location = incomingDamage.hitLocation
        let allLocations = BodyLocation.allCases
        var damages = [DamageRollResult]()
        
        incomingDamage.rollResult.forEach { rollResult in
            let location = location ?? allLocations.randomElement() ?? .Torso
            damages.append(DamageRollResult(location: location, amount: rollResult, type: damageType))
        }
        
        var wounds = [Wound]()
        
        if !damages.isEmpty {
            let result = edgerunner.equippedArmor.applyDamages(damages, coverSP: incomingDamage.coverSP)
            
            result.forEach { location, hits in
                hits.forEach { hit in
                    wounds.append(Wound(traumaType: Rules.Damage.traumaType(for: damageType), damageAmount: hit, location: location))
                }
            }
        }
        
        return wounds
    }
    
}
