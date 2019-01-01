//
//  RoleFieldLabel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/15/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Strings used in the Character Description View
enum RoleFieldLabel: String, EntryTypeProvider, CaseIterable {
    
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
    
    static func enforcedOrder() -> [Identifier] {
        return RoleFieldLabel.allCases.map { $0.identifier() }
    }
    
    /// NOTE: ORDERING IS ENFORCED. DO NOT CHANGE THE ORDER
    
    case name = "NAME"
    case handle = "HANDLE"
    case characterClass = "ROLE"
}
