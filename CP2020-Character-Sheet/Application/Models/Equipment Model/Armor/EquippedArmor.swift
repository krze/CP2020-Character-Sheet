//
//  EquippedArmor.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/20/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Contains a model for the armor equipped by the Edgerunner
final class EquippedArmor: Codable {
    
    /// All armor on the character
    private(set) var armor = [Armor]()
    
    /// Total EV penalty from armor and layered encumberance.
    private(set) var encumberancePenalty = 0
    
    /// The amount of damage to armor in the location. This subtracts the SP.
    private(set) var armorDamages = [ArmorDamage]()
    
    /// When EquippedArmor is created, the encumberance value is updated.
    init() {
        updateEncumberance()
    }
    
    /// Returns the SP value for the body part location, based on the New Armor Rules
    /// - Parameter location: The location that you need an SP value for
    func sp(for location: BodyLocation) -> Int {
        var previousLayerSP = 0
        var diffBonus = 0
        var largestSP = 0
        
        armor.forEach { thisLayer in
            if thisLayer.locations.contains(location) {
                let thisLayerSP = thisLayer.currentSP(for: location)
                if previousLayerSP > 0 {
                    let diff = abs(previousLayerSP - thisLayerSP)
                    diffBonus = diffBonus + spDiffBonus(fromDiff: diff)
                }
                
                if thisLayerSP > largestSP {
                    largestSP = thisLayerSP
                }
                
                previousLayerSP = thisLayerSP
            }
        }
        
        return largestSP + diffBonus
    }
    
    /// Indicates whether the location has sustained damage to the armor
    /// - Parameter location: The location that you need ArmorLocationStatus for
    func status(for location: BodyLocation) -> ArmorLocationStatus {
        let allStatuses = armor.filter({ $0.locations.contains(location) }).map { $0.status() }
        
        let armorIsDestroyed = allStatuses.contains(.Damaged)
        let armorIsDamaged = allStatuses.contains(.Destroyed)
        let armorIsUndamaged = allStatuses.contains(.Undamaged)
        
        // All armor is in this location has a status of destroyed
        if armorIsDestroyed && !armorIsDamaged && !armorIsUndamaged {
            return .Destroyed
        }
        // Armor is a mix of damaged or destroyed
        else if armorIsDamaged || armorIsDestroyed {
            return .Damaged
        }
        else {
            return .Undamaged
        }
    }
    
    /// Equips the armor specified.
    /// - Parameters:
    ///   - armor: The new armor to equip
    ///   - completion: The validation completion
    func equip(_ armor: Armor, validationCompletion completion: @escaping ValidatedCompletion) {
        guard CharacterValidator.validate(newArmor: armor, existingArmor: self.armor, completion: completion) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.armor.append(armor)
            self.armor.sortByZones()
            self.updateEncumberance()
            
            completion(.success(.valid(completion: { NotificationCenter.default.post(name: .armorDidChange, object: nil) })))
            self.saveCharacter()
        }

    }
    
    /// Removes the armor specified.
    ///
    /// - Parameters:
    ///   - armor: The new armor to remove
    ///   - completion: The validation completion
    func remove(_ armor: Armor, validationCompletion completion: @escaping ValidatedCompletion) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.armor.removeAll(where: { $0 == armor})
            self.armor.sortByZones()
            self.updateEncumberance()
            
            completion(.success(.valid(completion: { NotificationCenter.default.post(name: .armorDidChange, object: nil) })))
            
            self.saveCharacter()
        }
    }
    
    /// Applies the series of damages and locations, maintaining track of the coverSP and reducing it for repeated
    /// attacks. Returns the remaining damage, which should be applied to the location under the armor.
    ///
    /// - Parameters:
    ///   - damages: A series of DamageRollResults
    ///   - coverSP: The coverSP before the damage is applied
    ///   - leftoverDamageHandler: This closure is called for each event where the damage bypasses armor
    func applyDamages(_ damages: [DamageRollResult], coverSP: Int, leftoverDamageHandler: (Int, [BodyLocation], DamageType) -> Void) {
        var coverSP = coverSP
        
        for damage in damages {
            guard damage.locations.count == 1,
                let location = damage.locations.first
                else {
                    // Currently there are no cases where multi-location damage results in damage
                    // that does not ignore armor. Therefore, if there's more than one location, it must be
                    // ignoring armor.
                    
                    // First, iterate over all armor individually and apply damage to its affected parts
                    var allArmor = armor
                    while !allArmor.isEmpty {
                        let thisArmor = allArmor.removeFirst()
                        var affectedLocations = [BodyLocation]()
                        
                        for location in damage.locations {
                            // If the damage locations overlap with locations the armor covers,
                            // ensure only those locations are listed in the damage.
                            if thisArmor.locations.contains(location) {
                                affectedLocations.append(location)
                            }
                        }
                        
                        if !affectedLocations.isEmpty {
                            thisArmor.applyDamage(totalDamage: damage.amount, damageType: damage.type, locations: affectedLocations)
                        }
                    }
                    
                    // Then apply the full damage to the body, since this is definitely ignoring armor
                    leftoverDamageHandler(damage.amount, damage.locations, damage.type)
                    continue
            }
            let thisRemaining = applyDamage(damage.amount, damageType: damage.type, location: location, coverSP: coverSP)
            
            if thisRemaining > 0 {
                leftoverDamageHandler(thisRemaining, damage.locations, damage.type)

                if coverSP > 0 {
                 coverSP -= 1
                }
            }
        }
        
        NotificationCenter.default.post(name: .armorDidChange, object: nil)
    }
        
    /// Applies damage to the specified location. If any damage exceeds the armor, this will return a value > 0
    ///
    /// - Parameters:
    ///   - damage: Damage amount
    ///   - location: Location where the damage hit
    ///   - coverSP: The SP of the cover
    private func applyDamage(_ damage: Int, damageType: DamageType, location: BodyLocation, coverSP: Int) -> Int {
        var locationSP = Rules.WornArmor.effectiveSPValue(of: armorType(for: location),
                                                          sp: sp(for: location),
                                                          damageType: damageType)
        
        if coverSP > 0 {
            let diffBonus = spDiffBonus(fromDiff: abs(locationSP - coverSP))
            locationSP = locationSP > coverSP ? locationSP + diffBonus : coverSP + diffBonus
        }
        
        let remaining = damageType.ignoresArmor() ? damage : damage - locationSP
        
        if remaining > 0 || damageType.alwaysDamagesArmor() {
            let affectedArmor = armor.filter { $0.locations.contains(location) }
            affectedArmor.forEach { armor in
                armor.applyDamage(totalDamage: damage, damageType: damageType, location: location)
            }
            return remaining
        }
        
        return 0
    }
    
    private func spDiffBonus(fromDiff diff: Int) -> Int {
        guard diff >= 0 else { return 0 }
        
        return Rules.WornArmor.spDiffBonus(fromDiff: diff)
    }
    
    private func armorType(for location: BodyLocation) -> ArmorType {
        let armorCoveringLocation = armor.filter { $0.locations.contains(location) }
        
        return armorCoveringLocation.contains(where: { $0.type == .Hard }) ? .Hard : .Soft
    }
    
    /// Coalesces all the armor's inherent EV penalty on the character.
    private func armorEncumberancePenalty() -> Int {
        armor.reduce(0) { $0 + $1.ev }
    }

    /// Iterates through all the armor on the person and reports the encumberance penalty from wearing too many layers
    private func layeredArmorEncumberancePenalty() -> Int {
        guard !armor.isEmpty else { return 0 }
        var mutableArmor = armor
        var encumberingArmor = [Armor]()

        while !mutableArmor.isEmpty {
            // Pluck off each piece of armor and compare it to the rest. This is so it doesn't count the same piece twice.
            // For example: If you're wearing a bulky flak jacket, a 5 sp t-shirt, and a skinweave, you should only count
            // the layered encumberance once for the flak jacket. You don't double-penalize.
            let thisArmor = mutableArmor.removeFirst()
            for otherArmorPeice in mutableArmor {

                // If the armor being examined happens to overlap another piece, and it encumbers when layered, add it to the encumbering list
                if thisArmor.locations.overlaps(otherArmorPeice.locations) &&
                    thisArmor.encumbersWhenLayered() &&
                    otherArmorPeice.encumbersWhenLayered() {
                    encumberingArmor.append(thisArmor)
                    break // break just to be sure we don't overdo this. This is extra safety but better safe than sorry.
                }
            }
        }

        return encumberingArmor.count
    }
        
    private func saveCharacter() {
        // TODO: This is not a good pattern. Make a model manager that handles all modifications of the model and have it save there. Don't let the model save itself.
        NotificationCenter.default.post(name: .characterComponentDidRequestSaveToDisk, object: nil)
    }
    
    /// Updates the encumberance penalty. Encumberance is converted from a cumulative positive to the negative penalty here
    private func updateEncumberance() {
        encumberancePenalty = -(armorEncumberancePenalty() + layeredArmorEncumberancePenalty())
    }
    
    private enum Process {
        case adding, removing
    }
    
}
