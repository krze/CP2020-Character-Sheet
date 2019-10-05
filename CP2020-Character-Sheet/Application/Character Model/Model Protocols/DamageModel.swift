//
//  DamageModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/3/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol DamageModel {
    
    /// Current damage of the player
    var damage: Int { get }
    
    /// Current save of the player for stun or mortal saves
    var save: Int { get }
    
    /// The player's Body Type
    var bodyType: BodyType { get }
    
    /// Current Body Type Modifier of the player
    var btm: Int { get }
    
    /// Applies the damage described to the player.
    /// - Parameter damage: The incoming damage value (can be positive or negative)
    /// - Parameter completion: Completion closure called with validity state
    func apply(damage: Int, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void)
    
}
