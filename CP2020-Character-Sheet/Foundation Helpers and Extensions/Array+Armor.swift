//
//  Array+Armor.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 12/24/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

extension Array where Element == Armor {
    /// Modifies the sorted armor zones
    /// - Parameters:
    ///   - process: The specified process of either adding or removing
    ///   - armor: The armor under process
    mutating func sortByZones() {
        var zones = ArmorZone.allCases
        var sortedArmor = [Armor]()
        // Order the armor by layers from inside to out
        
        while !zones.isEmpty {
            let zone = zones.removeFirst()
            var armorInZone = self.filter { $0.zone == zone }
            
            armorInZone.sort(by: { $0.sp > $1.sp })
            armorInZone.forEach { armor in
                sortedArmor.append(armor)
            }
        }
        
        self = sortedArmor
    }
}
