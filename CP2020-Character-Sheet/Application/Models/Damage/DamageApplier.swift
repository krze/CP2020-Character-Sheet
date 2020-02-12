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
    static func applyArmorDamage(to edgerunner: ArmorModel & DamageModel, incomingDamage: IncomingDamage) -> [Wound] {
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
            edgerunner.equippedArmor.applyDamages(damages, coverSP: incomingDamage.coverSP)
            { leftoverDamage, locations, damageType in
                // This closure is only called when damage exceeds the armor protection.
                // Just in case, check to make sure we're working with damage to begin with
                guard leftoverDamage > 0 else { return }
                let leftoverDamage = Rules.Damage.effectiveDamage(of: damageType, amount: leftoverDamage, btm: edgerunner.btm)
                var traumaTypes = Rules.Damage.traumaTypes(for: damageType)

                // Cannot create extra damage. If there's only 1 point of damage, but multiple trauma types,
                // then don't bother trying to distribute this damage over multiple trauma types. Wounds that
                // have multiple trauma types are hard-coded to have the types ordered by the rules in the
                // book, so if there is less damage than trauma types, it will be given to the first trauma
                // type listed.
                //
                // Currently, there are no damages that cause more than two trauma types.
                if traumaTypes.count > 1 && leftoverDamage > traumaTypes.count {
                    let amountPerWound = leftoverDamage / traumaTypes.count
                    let remainder = leftoverDamage % traumaTypes.count

                    while traumaTypes.count > 0 {
                        let traumaType = traumaTypes.removeFirst()
                        let amount = traumaTypes.isEmpty ? amountPerWound + remainder : amountPerWound

                        wounds.append(contentsOf: distribute(damage: amount, overLocations: locations, traumaType: traumaType))
                    }
                }
                else if let traumaType = traumaTypes.first {
                    wounds.append(contentsOf: distribute(damage: leftoverDamage, overLocations: locations, traumaType: traumaType))
                }
            }
        }
        
        return wounds
    }
    
    private static func distribute(damage: Int, overLocations locations: [BodyLocation], traumaType: TraumaType) -> [Wound] {
        var locations = locations.shuffled()
        
        // The minimum amount of damage a location can receive is 1 point. We cannot distribute more
        // damage than there are locations on the body, therefore, this loop removes locations from
        // the array until, at minimum, the locations left will receive at least 1 point of damage
        while locations.count > damage {
            locations.removeFirst()
        }
        
        let damagePerWound = damage / locations.count
        let remainder = damage % locations.count
        var wounds = [Wound]()
        
        while locations.count > 0 {
            let location = locations.removeFirst()
            let amount = locations.isEmpty ? damagePerWound + remainder : damagePerWound
            let finalAmount = location == .Head ? amount * Rules.Damage.headWoundMultiplier : amount
            
            wounds.append(Wound(traumaType: traumaType, damageAmount: finalAmount, location: location))
        }
        
        return wounds
    }
    
}
