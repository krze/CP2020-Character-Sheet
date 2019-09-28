//
//  DamageModifierDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/26/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Manages the status of the characters' damage modifiers in order to make UI updates to the DamageModifierViewCell
final class DamageModifierDataSource: EditorValueReciever {
    func valuesFromEditorDidChange(_ values: [Identifier : String], validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        
    }
    
    func refreshData() {
        
    }
    
    private weak var delegate: DamageModifierDataSourceDelegate?

    // TODO: Fill this out to modify the cell values within this section
    
}
