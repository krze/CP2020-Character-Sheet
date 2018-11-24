//
//  TotalDamageControllerDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Responds to calls from the TotalDamageController
protocol TotalDamageControllerDelegate: class {
    var damageCells: [UIView] { get }
    
    //TODO: Arrange the relationship between the TotalDamageController and the DamageViewCell via the delegate
}
