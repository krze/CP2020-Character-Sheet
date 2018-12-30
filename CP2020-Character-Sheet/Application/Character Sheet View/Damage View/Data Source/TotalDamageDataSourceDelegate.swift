//
//  TotalDamageDataSourceDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Responds to calls from the TotalDamageController
protocol TotalDamageDataSourceDelegate: class {
    var damageCells: [UIView] { get }
    
    /// Updates the damage cells to display the current value
    ///
    /// - Parameter currentDamage: The current damage the character has
    func updateCells(to newDamage: Int)
}
