//
//  DeadViewManager.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 4/4/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

final class DeadViewManager {
    private weak var model: LivingStateModel?
    
    init(model: LivingStateModel) {
        self.model = model
    }
    
    /// Increments the dead state and returns the new numeric value of the state
    func incrementDeadState() -> LivingState? {
        guard canChange(direction: .up), let deadState = model?.livingState else { return nil }
        let newValue = deadState.rawValue + 1
        
        if let newState = LivingState(rawValue: newValue) {
            model?.enter(livingState: newState, completion: defaultCompletion)
            return newState
        }
        
        return nil
    }
    
    /// Decrements the dead state and returns the new new numeric value of the state
    func decrementDeadState() -> LivingState? {
        guard canChange(direction: .down), let deadState = model?.livingState else { return nil }
        let newValue = deadState.rawValue - 1
        
        if let newState = LivingState(rawValue: newValue) {
            model?.enter(livingState: newState, completion: defaultCompletion)
            return newState
        }
        
        return nil
    }
    
    /// Clears the dead state and revives the player back to the living
    func clearDeadState() {
        model?.enter(livingState: .alive, completion: defaultCompletion)
    }
    
    private func canChange(direction: Direction) -> Bool {
        guard let deadState = model?.livingState, deadState.rawValue >= 0 else { return false }
         
        switch direction {
            case .down: return deadState.rawValue >= 1
            case .up: return deadState.rawValue <= 9
        }
    }
    
    enum Direction {
        case up, down
    }
}
