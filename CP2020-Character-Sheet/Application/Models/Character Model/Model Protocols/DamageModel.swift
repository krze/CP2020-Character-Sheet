//
//  DamageModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/3/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol DamageModel: class {
    
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
    func apply(damage: IncomingDamage, validationCompletion completion: @escaping ValidatedCompletion)
    
    /// Removes the wound specified.
    ///
    /// - Parameters:
    ///   - wound: The wound to remove
    ///   - completion: The validation completion
    func remove(_ wound: Wound, validationCompletion completion: @escaping ValidatedCompletion)
    
    /// Removes all wounds of the trauma type specified.
    ///
    /// - Parameters:
    ///   - traumaType: The trauma type to remove
    ///   - completion: The validation completion
    func removeAll(_ traumaType: TraumaType, validationCompletion completion: @escaping ValidatedCompletion)
    
    /// Reduces the damage of the wound specified
    /// - Parameters:
    ///   - wound: The wound to heal or repair
    ///   - amount: The amount to reduce the damage
    ///   - completion: The validation completion
    func reduce(wound: Wound, amount: Int, validationCompletion completion: @escaping ValidatedCompletion)
    
}
