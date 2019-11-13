//
//  ArmorModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/12/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol ArmorModel {
    
    /// Contains and manages equipped armor. If a character has no armor, this will be nil
    var equippedArmor: EquippedArmor { get }
    
}
