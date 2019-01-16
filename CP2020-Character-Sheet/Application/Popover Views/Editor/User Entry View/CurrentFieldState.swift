//
//  CurrentFieldState.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/1/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

struct CurrentFieldState {
    
    let identifier: Identifier
    let description: String?
    let currentValue: String
    let entryType: EntryType
    
    init(identifier: Identifier, currentValue: String, entryType: EntryType) {
        self.identifier = identifier
        self.currentValue = currentValue
        self.entryType = entryType
        self.description = nil
    }
}

extension Array where Element == CurrentFieldState {
    
    func popoverViewModelParameters() -> (rowsWithIdentifiers: [String: EntryType], entryTypes: [EntryType], placeholdersWithIdentifiers: [Identifier: String]) {
        var rowsWithIdentifiers = [Identifier: EntryType]()
        var entryTypes = [EntryType]()
        var placeholdersWithIdentifiers = [String: String]()
        
        self.forEach { fieldState in
            let identifier = fieldState.identifier
            let entryType = fieldState.entryType
            
            rowsWithIdentifiers[identifier] = entryType
            placeholdersWithIdentifiers[identifier] = fieldState.currentValue
            entryTypes.append(entryType)
        }
        
        return (rowsWithIdentifiers, entryTypes, placeholdersWithIdentifiers)
    }
    
}

extension Array where Element == EntryType {
    
    func rowsNecessaryForColumn(count columns: Int) -> Int {
        let remainder = count % columns
        
        return count / columns + (remainder > 0 ? 1 : 0)
    }
}
