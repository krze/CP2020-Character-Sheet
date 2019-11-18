//
//  EditorCollectionViewModel+Role.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 8/18/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

extension EditorCollectionViewModel {
    
    static func model(with currentRole: Role?, name: String, handle: String) -> EditorCollectionViewModel {
        var entryTypesForIdentifiers = [Identifier: EntryType]()
        var placeholdersWithIdentifiers = [Identifier: String]()
        var descriptionsWithIdentifiers = [Identifier: String]()
        
        RoleFieldLabel.allCases.forEach { label in
            let identifier = label.identifier()
            entryTypesForIdentifiers[identifier] = label.entryType(mode: .free)
            placeholdersWithIdentifiers[identifier] = {
                switch label {
                case .CharacterRole:
                    return currentRole?.rawValue ?? ""
                case .Handle:
                    return handle
                case .Name:
                    return name
                }
            }()
            
            descriptionsWithIdentifiers[identifier] = description(for: label)
        }
        
        return EditorCollectionViewModel(layout: .editorDefault(), entryTypesForIdentifiers: entryTypesForIdentifiers, placeholdersWithIdentifiers: placeholdersWithIdentifiers, descriptionsWithIdentifiers: descriptionsWithIdentifiers, enforcedOrder: RoleFieldLabel.enforcedOrder(), mode: .free)
    }
    
    private static func description(for roleField: RoleFieldLabel) -> String {
        switch roleField {
        case .CharacterRole:
            return RoleStrings.roleDescription
        case .Handle:
            return RoleStrings.handleDescription
        case .Name:
            return RoleStrings.nameDescription
        }
    }
    
}
