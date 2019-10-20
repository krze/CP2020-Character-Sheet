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
    
    /// All armor worn
    private(set) var armor = [Armor]()
    /// Encumbrance penalty induced by layered armor
    private(set) var layeredEncumberance = 0
    
    /// The ordering of armor worn
    private var order = [Int: Armor]()
    
    /// Equips the armor, inserting it in the correct location first by ArmorZone, then by SPS value.
    /// This layering order determines the final SPS per location based on the layered armor rules.
    ///
    /// - Parameter armor: The new armor to equip
    func equip(_ armor: Armor) {
        self.armor.append(armor)

        var mutableOrder = [Int: Armor]()
        var currentLayer = 0
        var zones = ArmorZone.allCases
        
        // Order the armor by layers from inside to out
        
        while !zones.isEmpty {
            let zone = zones.removeFirst()
            var armorInZone = self.armor.filter { $0.zone == zone }
            if armor.zone == zone {
                armorInZone.append(armor)
            }
            
            armorInZone.sort(by: { $0.sps > $1.sps })
            armorInZone.forEach { armor in
                mutableOrder[currentLayer] = armor
                currentLayer += 1
            }
        }
        
        order = mutableOrder
        updateEncumberance()
    }
    
    func currentEV() -> Int {
        layeredEncumberance + armor.reduce(0) { $0 + $1.ev }
    }
    
    /// Returns the SPS value for the body part location, based on the New Armor Rules
    /// - Parameter location: The location that you need an SPS value for
    func sps(for location: BodyLocation) -> Int {
        var currentLayer = 0
        var sps = 0
        
        while let thisLayer = order[currentLayer] {
            if thisLayer.locations.contains(location) {
                if sps > 0 {
                    let diff = abs(sps - thisLayer.currentSPS())
                    sps = sps > thisLayer.currentSPS() ? sps + diff : thisLayer.currentSPS() + diff
                }
                else {
                    sps = thisLayer.currentSPS()
                }
            }
            currentLayer += 1
        }
        
        return sps
    }
    
    private func updateEncumberance() {
        guard order.keys.count > 1 else { return }
        
        var encumberance = 0
        var currentLayer = 0
        
        while let thisLayer = order[currentLayer], let nextLayer = order[currentLayer + 1] {
            if thisLayer.encumbersWhenLayered() && nextLayer.encumbersWhenLayered(),
                thisLayer.locations.overlaps(nextLayer.locations){
                encumberance += 1
            }
            
            currentLayer += 1
        }
        
        self.layeredEncumberance = encumberance
    }
    
}
