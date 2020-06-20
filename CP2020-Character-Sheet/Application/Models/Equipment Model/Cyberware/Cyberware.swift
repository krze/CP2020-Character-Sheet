//
//  Cyberware.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 5/22/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

final class Cyberware: HumanityCosting, Codable {
    let humanityCost: Int
    
    let name: String
    let price: Int
    private(set) var description: String
    var equipped: Equipped = .equipped
    
    /// How much SDP are added to the location with this enhancement installed
    let sdpEnhancement: Int?
    
    /// The number of slots the cyberware occupies in a location, if any
    let slotsOccupied: Int
    
    let uniqueID = UUID()
    
    var containerID: UUID?
    
    init(name: String, price: Int, description: String, sdpEnhancement: Int?, slotsOccupied: Int, humanityCost: Int) {
        self.name = name
        self.price = price
        self.description = description
        self.sdpEnhancement = sdpEnhancement
        self.slotsOccupied = slotsOccupied
        self.humanityCost = humanityCost
    }
    
}
