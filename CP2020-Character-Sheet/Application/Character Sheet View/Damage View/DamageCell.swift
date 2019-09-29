//
//  DamageCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 9/29/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A simple view that has an API to indicate damage/undamaged state
final class DamageCell: UIView {
    
    /// Marks the cell as damaged
    func markAsDamaged() {
        self.backgroundColor = StyleConstants.Color.red
    }
    
    /// Marks the cell as undamaged
    func markAsUndamaged() {
        self.backgroundColor = StyleConstants.Color.light
    }
    
}
