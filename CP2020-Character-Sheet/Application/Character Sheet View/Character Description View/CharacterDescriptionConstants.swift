//
//  CharacterDescriptionConstants.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/15/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Strings used in the Character Description View
enum RoleFieldLabel: String, EntryTypeProvider {
    
    func identifier() -> String {
        return self.rawValue
    }
    
    func entryType() -> EntryType {
        switch self {
        case .name, .handle:
            return .Text
        case .characterClass:
            let classes = Role.allCases.map { $0.rawValue }
            return .Picker(classes)
        }
    }
    
    
    
    case name = "NAME"
    case handle = "HANDLE"
    case characterClass = "ROLE"
}
