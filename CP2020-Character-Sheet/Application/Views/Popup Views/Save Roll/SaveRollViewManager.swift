//
//  SaveRollViewManager.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/13/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

final class SaveRollViewManager {
    
    weak var damageModel: DamageModel?

    private var rolls = [SaveRoll]()
    
    func append(rolls: [SaveRoll]) {
        self.rolls.append(contentsOf: rolls)
    }
    
    @objc func resolveRolls() {
        rolls.forEach { roll in
            let succeeded = roll.resolve()
                        
            switch roll.type {
            case .Mortal:
                succeeded ? print("Phew") : print("ARHG")
            case .Stun:
                succeeded ? print("Phew") : print("ARHG")
            }
        }
    }
    
    @objc func dismiss() {
        damageModel?.clearSaveRolls()
    }
    
    @objc func acceptStunned() {
        damageModel?.enter(livingState: .stunned)
    }
    
    @objc func acceptDeath() {
        damageModel?.enter(livingState: .dead0)
    }
    
}
