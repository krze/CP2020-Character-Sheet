//
//  CharacterSheetSections.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

enum CharacterSheetSections: Int {
    case Damage
    
    func cellReuseID() -> String {
        switch self {
        case .Damage:
            return "damageID"
        }
    }
}

extension CharacterSheetSections: CaseIterable {}
