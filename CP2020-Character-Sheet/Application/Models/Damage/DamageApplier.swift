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
    
    /// Applies damage to the Edgerunner. Any damage that exceeds the Edgerunner's maximum damage will be ignored.
    /// Returns any wounds that would be sustained by the edgerunner.
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
                    var traumaTypes = Rules.Damage.traumaType(for: damageType)
                    
                    if traumaTypes.count > 0 {
                        let amountPerWound = hit / traumaTypes.count
                        let remainder = hit % traumaTypes.count
                        
                        while traumaTypes.count > 1 {
                            let thisType = traumaTypes.removeFirst()
                            let amount = traumaTypes.isEmpty ? amountPerWound + remainder : amountPerWound
                            
                             wounds.append(Wound(traumaType: thisType, damageAmount: amount, location: location))
                        }
                    }
                    else {
                        if let traumaType = traumaTypes.first {
                            wounds.append(Wound(traumaType: traumaType, damageAmount: hit, locations: location))
                        }
                    }
                    
                }
            }
        }
        
        return wounds
    }
    
}
