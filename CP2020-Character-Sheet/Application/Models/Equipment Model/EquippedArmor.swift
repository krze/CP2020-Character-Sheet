//
//  EquippedArmor.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/20/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Contains a model for the armor equipped by the player
final class EquippedArmor: Codable {
    
    /// All armor on the character
    private(set) var armor = [Armor]()
    
    /// Total EV penalty from armor and layered encumberance
    private(set) var encumberancePenalty = 0
    
    /// The ordering of armor worn. This is from the most internal ArmorZone outward. Within each zone, armor is sorted
    /// by greatest to least SP value.
    private(set) var order = [Int: Armor]()
    
    /// When EquippedArmor is created, the encumberance value is updated.
    init() {
        updateEncumberance()
    }
    
    /// Returns the SP value for the body part location, based on the New Armor Rules
    /// - Parameter location: The location that you need an SP value for
    func sp(for location: BodyLocation) -> Int {
        var currentLayer = 0
        var sp = 0
        
        while let thisLayer = order[currentLayer] {
            if thisLayer.locations.contains(location) {
                if sp > 0 {
                    let diff = abs(sp - thisLayer.currentSP())
                    sp = sp > thisLayer.currentSP() ? sp + diff : thisLayer.currentSP() + diff
                }
                else {
                    sp = thisLayer.currentSP()
                }
            }
            currentLayer += 1
        }
        
        return sp
    }
    
    /// Indicates whether the location has sustained damage to the armor
    /// - Parameter location: The location that you need ArmorLocationStatus for
    func status(for location: BodyLocation) -> ArmorLocationStatus {
        return armor.filter({ $0.locations.contains(location) }).contains(where: { $0.damageSustained > 0 }) ? .Damaged : .Undamaged
    }
    
    /// Equips the armor specified.
    /// - Parameters:
    ///   - armor: The new armor to equip
    ///   - completion: The validation completion
    func equip(_ armor: Armor, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        modifyArmorZones(.adding, armor)
        self.armor.append(armor)
        updateEncumberance()
    }
    
    /// Removes the armor specified.
    ///
    /// - Parameters:
    ///   - armor: The new armor to remove
    ///   - completion: The validation completion
    func remove(_ armor: Armor, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        modifyArmorZones(.removing, armor)
        self.armor.removeAll(where: { $0 == armor})
        updateEncumberance()
    }
    
    /// Coalesces all the armor's inherent EV penalty on the character.
    func armorEncumberancePenalty() -> Int {
        armor.reduce(0) { $0 + $1.ev }
    }

    /// Iterates through all the armor on the person and reports the encumberance penalty from wearing too many layers
    func layeredArmorEncumberancePenalty() -> Int {
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

        return -encumberingArmor.count
    }
    
    /// Modifies the sorted armor zones
    /// - Parameters:
    ///   - process: The specified process of either adding or removing
    ///   - armor: The armor under process
    private func modifyArmorZones(_ process: Process, _ armor: Armor) {
        var mutableOrder = [Int: Armor]()
        var currentLayer = 0
        var zones = ArmorZone.allCases
        
        // Order the armor by layers from inside to out
        
        while !zones.isEmpty {
            let zone = zones.removeFirst()
            var armorInZone = self.armor.filter { $0.zone == zone }
            if armor.zone == zone {
                process == .adding ? armorInZone.append(armor) : armorInZone.removeAll(where: { $0 == armor})
            }
            
            armorInZone.sort(by: { $0.sp > $1.sp })
            armorInZone.forEach { armor in
                mutableOrder[currentLayer] = armor
                currentLayer += 1
            }
        }
        order = mutableOrder
    }
    
    private func updateEncumberance() {
        encumberancePenalty = armorEncumberancePenalty() + layeredArmorEncumberancePenalty()
    }
    
    private enum Process {
        case adding, removing
    }
    
}
