//
//  LivingStateModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 4/4/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol LivingStateModel: class {
    
    /// Indicates the state of the player
    var livingState: LivingState { get }
    
    /// SaveRolls that need to be resolved
    var saveRolls: [SaveRoll] { get }
    
    /// Removes all save rolls without rolling
    /// - Parameter completion: Completion closure called with validity state
    func clearSaveRolls(completion: @escaping (ValidatedResult) -> Void)
    
    /// Applies the damage described to the Edgerunner.
    /// - Parameters:
    ///   - livingState: The new living state
    ///   - completion: Completion closure called with validity state
    func enter(livingState: LivingState, completion: @escaping (ValidatedResult) -> Void)
    
}
