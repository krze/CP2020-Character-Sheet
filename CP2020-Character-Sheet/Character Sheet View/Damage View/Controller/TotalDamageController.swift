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
    private var currentDamage: Int = 0
    private var pendingDamage = 0
    private weak var delegate: TotalDamageControllerDelegate?
    
    init(maxDamage: Int, delegate: TotalDamageControllerDelegate) {
        self.maxDamage = maxDamage
        self.delegate = delegate
    }
    
    func modifyDamage(by amount: Int) {
        validate(damage: amount + currentDamage) // ERror this out
        
        delegate?.updateCells(to: currentDamage)
    }
    
    func getLatestDamage(completion: @escaping (Int) -> Void) {
        DispatchQueue.main.async {
            guard let latestDamage = self.delegate?.damageCells.filter({ $0.backgroundColor == .red }).count else {
                return
            }
            
            self.currentDamage = latestDamage
            completion(latestDamage)
        }
    }
    
    private func validate(damage: Int) {
        guard delegate?.damageCells.indices.contains(damage) == true,
            0...maxDamage ~= currentDamage + damage else {
            return
        }
    }
    
    private func updateCurrentDamage(to damage: Int?) {
        guard let damage = damage else {
            return
        }
        currentDamage = damage
    }
}

enum DamageModification: Error {
    case OutOfBounds, CouldNotGetCurrentDamage
}
