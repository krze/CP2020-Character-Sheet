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
        for roll in rolls {
            // Skip if the resolution comes back as a success
            guard !roll.resolve() else { continue }
                  
            switch roll.type {
            case .Mortal:
                acceptDeath()
            case .Stun:
                acceptStunned()
            }
            
            break
        }
        
        dismiss()
        rolls = [SaveRoll]()
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
