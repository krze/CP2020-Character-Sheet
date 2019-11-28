//
//  DamageField.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

enum DamageField: String, EntryTypeProvider, CaseIterable {
    case NumberOfHits, Roll, Location, DamageType

    func identifier() -> Identifier {
        switch self {
        case .NumberOfHits:
            return DamageStrings.numberOfHits
        default:
            <#code#>
        }
    }
    
    func entryType(mode: EditorMode) -> EntryType {
        <#code#>
    }
    
    static func enforcedOrder() -> [String] {
        <#code#>
    }
    
    
}
