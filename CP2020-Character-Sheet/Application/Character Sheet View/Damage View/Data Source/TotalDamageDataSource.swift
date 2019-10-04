//
//  TotalDamageDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

final class TotalDamageDataSource: EditorValueReciever {

    private let model: DamageModel
    private let maxDamage: Int
    var currentDamage: Int {
        return model.damage
    }
    weak var delegate: TotalDamageDataSourceDelegate?
    
    init(model: DamageModel) {
        self.model = model
        self.maxDamage = Rules.Damage.maxDamagePoints
    }
    
    /// Iterates damage up by 1 damage point. Updates the delegate's damage cells.
    ///
    /// - Throws: DamageModification error if the damage could not be applied
    func iterateDamageUp() throws {
        try modifyDamage(by: 1)
    }
    
    /// Iterates damage down by 1 damage point. Updates the delegate's damage cells.
    ///
    /// - Throws: DamageModification error if the damage could not be applied
    func iterateDamageDown() throws {
        try modifyDamage(by: -1)
    }
    
    /// Modifies the damage by the amount specified. Updates the delegate's damage cells.
    ///
    /// - Parameter amount: The amount to modify the damage by. Can be positive or negative.
    /// - Throws: DamageModification error if the damage could not be applied
    func modifyDamage(by amount: Int) throws {
        do {
            try validate(newDamage: amount)
            model.apply(damage: amount)
        }
        catch let error {
            throw error
        }
        
        delegate?.updateCells(to: currentDamage)
    }
    
    /// This does nothing on TotalDamageDataSource since it doesnt have a fullscreen editor
    /// - Parameter values: _
    /// - Parameter completion: _
    func valuesFromEditorDidChange(_ values: [Identifier : String], validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {}
    
    func refreshData() {
        delegate?.updateCells(to: currentDamage)
    }
    
    /// Ensure the new damage applied can be applied
    ///
    /// - Parameter newDamage: The new damage to add to the current damage
    private func validate(newDamage: Int) throws {
        let (pendingCurrentDamage, didOverflow): (Int, Bool) = currentDamage.addingReportingOverflow(newDamage)
        guard !didOverflow else {
            throw DamageModification.BufferOverflow
        }
        
        guard pendingCurrentDamage >= 0 else {
            throw DamageModification.CannotGoBelowZero
        }
        
        guard pendingCurrentDamage <= Rules.Damage.maxDamagePoints else {
            throw DamageModification.CannotExceedMaxDamage
        }
        
        guard pendingCurrentDamage != currentDamage else {
            throw DamageModification.NoModification
        }
    }
    
    
}

/// An error that occurs when attempting to modify the current damage, but failed
///
/// - CannotGoBelowZero: The damage applied would have resulted in a negative damage value
/// - BufferOverflow: The damage applied overflowed Int.max or Int.min
/// - NoModification: The damage applied would have resulted in no change to the damage
enum DamageModification: Error {
    case CannotGoBelowZero, CannotExceedMaxDamage, BufferOverflow, NoModification
}
