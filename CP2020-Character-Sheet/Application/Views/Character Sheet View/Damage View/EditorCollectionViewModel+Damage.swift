//
//  EditorCollectionViewModel+Damage.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/2/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

extension EditorCollectionViewModel {
    
    func incomingDamage() -> EditorCollectionViewModel {
        let mode = EditorMode.free
        let allDamageFields = DamageField.allCases
        var entryTypesForIdentifiers = [Identifier: EntryType]()
        var placeholdersWithIdentifiers = [Identifier: String]()
        var descriptionsWithIdentifiers = [Identifier: String]()
        
        
        allDamageFields.forEach { field in
            let identifier = field.identifier()
            entryTypesForIdentifiers[identifier] = field.entryType(mode: mode)
            placeholdersWithIdentifiers[identifier] = field.defaultPlaceholder()
            descriptionsWithIdentifiers[identifier] = description(for: field)
        }
        
        return EditorCollectionViewModel(layout: .editorDefault(),
                                         entryTypesForIdentifiers: entryTypesForIdentifiers,
                                         placeholdersWithIdentifiers: placeholdersWithIdentifiers,
                                         descriptionsWithIdentifiers: descriptionsWithIdentifiers,
                                         enforcedOrder: DamageField.enforcedOrder(),
                                         mode: mode)
    }
    
    private func description(for field: DamageField) -> String {
        switch field {
        case .Roll:
            return DamageStrings.damageRollDescription
        case .NumberOfHits:
            return DamageStrings.numberOfHitsDescription
        case .Location:
            return DamageStrings.locationDescription
        case .DamageType:
            return DamageStrings.damageTypeDescription
        case .CoverSP:
            return DamageStrings.coverSPDescription
        }
    }
    
}
