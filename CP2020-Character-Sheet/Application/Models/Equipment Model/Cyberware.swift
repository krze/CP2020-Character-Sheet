//
//  Cyberware.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 5/22/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

final class Cyberware:  SortableEquipment {
    let name: String
    let cost: Double
    private(set) var description: String
    var equipped: Equipped = .equipped
    
    let sdpEnhancement: Int?
    let slotsOccupied: Int
    
    init(name: String, euroCost: Double, description: String, sdpEnhancement: Int?, slotsOccupied: Int) {
        self.name = name
        self.cost = euroCost
        self.description = description
        self.sdpEnhancement = sdpEnhancement
        self.slotsOccupied = slotsOccupied
    }
    
}
