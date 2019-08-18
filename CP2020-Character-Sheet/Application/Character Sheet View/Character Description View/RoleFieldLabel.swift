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
    /// NOTE: ORDERING IS ENFORCED. DO NOT CHANGE THE ORDER
    case Name
    case Handle
    case CharacterRole = "Role"
    
    func identifier() -> String {
        return self.rawValue
    }
    
    func entryType(mode: EditorMode) -> EntryType {
        switch self {
        case .Name, .Handle:
            return .Text
        case .CharacterRole:
            let classes = Role.allCases.map { $0.rawValue }
            return .EnforcedChoiceText(classes)
        }
    }
    
    static func enforcedOrder() -> [Identifier] {
        return RoleFieldLabel.allCases.map { $0.identifier() }
    }

}
