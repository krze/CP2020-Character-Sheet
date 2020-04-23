//
//  Cyberware.swift
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

final class Cyberware: HumanityCosting, StandardDamage {
    
    let name: String
    private(set) var description: String
    let humanityCost: Int
    let cost: Double
    
    let totalSDP: Int
    private(set) var currentDamage: Int = 0
    var currentSDP: Int {
        return totalSDP - currentDamage
    }


    init(name: String, description: String, humanityCost: Int, euroCost: Double, SDP: Int) {
        self.name = name
        self.description = description
        self.humanityCost = humanityCost
        self.cost = euroCost
        self.totalSDP = SDP
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
    
}
