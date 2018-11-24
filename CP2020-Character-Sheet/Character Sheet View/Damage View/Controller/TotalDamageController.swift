//
//  TotalDamageController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

final class TotalDamageController {
    private let maxDamage: Int
    private weak var delegate: TotalDamageControllerDelegate?
    
    init(maxDamage: Int, delegate: TotalDamageControllerDelegate) {
        self.maxDamage = maxDamage
        self.delegate = delegate
    }
    
    func iterateDamage() throws {
        let currentDamage = delegate?.damageCells.filter({ $0.backgroundColor == .red }).count
        guard delegate?.damageCells.indices.contains(currentDamage ?? Int.max) == true else {
            throw DamageCellError.ExceedsMaxDamage
        }
    }
}
