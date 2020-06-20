//
//  Cyberpart.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 4/22/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Describes equipment that costs humanity
protocol HumanityCosting: SortableEquipment {
    
    /// The humanity cost to posess the equipment
    var humanityCost: Int { get }
    
}

/// Describes items that can take damage
protocol StandardDamage {
    
    /// The totap Standard Damage Points the object posesses
    var totalSDP: Int { get }
    
    /// The current amount of damage the object has sustained
    var currentDamage: Int { get }
    
    /// The current amount of damage the object has sustained
    var currentSDP: Int { get }
    
    /// Apply damage to the object
    /// - Parameter damage: The amount to apply
    func apply(damage: Int)
    
    /// Repairs the described amount
    /// - Parameter amount: Amount to repair
    func repair(amount: Int)
    
    /// Repairs the item completely
    func repairAll()
    
}

/// Replaces an entire BodyLocation with a cybernetic replacement
final class CyberBodyPart: HumanityCosting, StandardDamage, Codable {
    var equipped: Equipped = .equipped
    
    let name: String
    private(set) var description: String
    let humanityCost: Int
    let cost: Double
    
    /// The total SDP available including any boots from Cyberware
    var totalSDP: Int {
        return baseSDP + bonusSDP
    }
    
    /// The base SDP of the part before enhancement
    private let baseSDP: Int
    
    private var bonusSDP = 0
    
    /// Current decremented damge
    private(set) var currentDamage: Int = 0
    
    var currentSDP: Int {
        return totalSDP - currentDamage
    }
    
    /// The number of slots available for enhancements
    let slots: Int
    
    /// The location this part replaces
    let location: CyberPartLocation
    
    let uniqueID = UUID()
    
    /// Contains IDs of the equipment that occupies these slots
    private(set) var slottedEquipment = [UUID]()

    init(name: String, description: String, humanityCost: Int, euroCost: Double, baseSDP: Int, slots: Int, location: CyberPartLocation) {
        self.name = name
        self.description = description
        self.humanityCost = humanityCost
        self.cost = euroCost
        self.baseSDP = baseSDP
        self.slots = slots
        self.location = location
    }
    
    func apply(damage: Int) {
        currentDamage += damage
    }
    
    func repair(amount: Int) {
        let newDamage = currentDamage - amount
        currentDamage = newDamage >= 0 ? newDamage : 0
    }
    
    func repairAll() {
        currentDamage = 0
    }
    
    func install(_ cyberware: Cyberware) {
        guard slottedEquipment.count <= slots else { return } // TODO: Throw error
        cyberware.containerID = uniqueID
        bonusSDP += cyberware.sdpEnhancement ?? 0
        slottedEquipment.append(cyberware.uniqeID)
    }
    
    func uninstall(_ cyberware: Cyberware) {
        guard slottedEquipment.contains(cyberware.uniqeID) else { return  } // TODO: Throw error
        slottedEquipment.removeAll(where: { $0 == cyberware.uniqeID })
        bonusSDP -= cyberware.sdpEnhancement ?? 0
        cyberware.containerID = nil
    }
    
}

// Scratchpad
/*
Types of equipment:
 Equipment - general
 Weapon
 Armor - worn or goes in the body. Already created. TODO: Make Armor `Sortable Equipment`
 
 Cyberware - implanted, costs humanity
 Cyberweapon - requires cyberpart and costs humanity, acts as a weapon
 CyberBodyPart (Cyberlimbs, and torso + head for cyborgs) - costs humanity, can act as a weapon
*/
