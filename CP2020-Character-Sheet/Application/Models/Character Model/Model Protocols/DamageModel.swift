//
//  DamageModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/3/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol DamageModel {
    
    /// Current damage of the Edgerunner
    var damage: Int { get }
    
    /// Current save of the Edgerunner for stun or mortal saves
    var save: Int { get }
    
    /// The Edgerunner's Body Type
    var bodyType: BodyType { get }
    
    /// Current Body Type Modifier of the Edgerunner
    var btm: Int { get }
    
    /// Current wounds the edgerunner has sustained
    var wounds: [Wound] { get }
    
    /// Applies the damage described to the Edgerunner.
    ///
    /// - Parameters:
    ///   - damage: The incoming damage value
    ///   - completion: Completion closure called with validity state
    func apply(damage: IncomingDamage, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void)
    
    /// Removes the wound specified.
    ///
    /// - Parameters:
    ///   - wound: The wound to remove
    ///   - completion: The validation completion
    func remove(_ wound: Wound, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void)
}
