//
//  EditorCollectionViewModel+Damage.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/2/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

extension EditorCollectionViewModel {
    
    func incomingDamage() {
        let mode = EditorMode.free
        let allDamageFields = DamageField.allCases
        var entryTypesForIdentifiers = [Identifier: EntryType]()
        var placeholdersWithIdentifiers = [Identifier: String]()
        var descriptionsWithIdentifiers = [Identifier: String]()
        
        
        allDamageFields.forEach { field in
            let identifier = field.identifier()
            entryTypesForIdentifiers[identifier] = field.entryType(mode: mode)
            
        }
    }
    
}
