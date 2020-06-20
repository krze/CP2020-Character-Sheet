//
//  SortableEquipment.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 4/22/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Describes a set of properties used to display the equipment that belongs to the player in a list
protocol SortableEquipment: Equippable {
    
    /// What the equipment is called
    var name: String { get }
    
    /// The value the player paid for the equipment
    var price: Int { get }
    
    /// The description of the equipment
    var description: String { get }
    
    /// Unique ID to identify the equipment
    var uniqueID: UUID { get }
    
}
