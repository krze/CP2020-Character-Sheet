//
//  DamageField.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

enum DamageField: String, EntryTypeProvider, CaseIterable {
    case NumberOfHits, Roll, Location, DamageType, CoverSP
    
    private typealias TypeOfDamage = CP2020_Character_Sheet.DamageType
    
    func identifier() -> Identifier {
        switch self {
        case .NumberOfHits:
            return DamageStrings.numberOfHits
        case .DamageType:
            return DamageStrings.damageType
        case .CoverSP:
            return DamageStrings.coverSP
        default:
            return rawValue
        }
    }
    
    func entryType(mode: EditorMode) -> EntryType {
        switch self {
        case .NumberOfHits, .CoverSP:
            return .Integer
        case .Roll:
            return .DiceRoll
        case .Location:
            return .Checkbox(locationCheckboxConfig())
        case .DamageType:
            return .Checkbox(TypeOfDamage.checkboxConfig())
        }
    }
    
    func defaultPlaceholder() -> AnyHashable {
        switch self {
        case .CoverSP:
            return "0"
        case .NumberOfHits:
            return ""
        case .Roll:
            return DiceRoll(number: 0, sides: 0, modifier: nil)
        case .Location:
            return locationCheckboxConfig()
        case .DamageType:
            return TypeOfDamage.checkboxConfig()
        }
    }
    
    static func enforcedOrder() -> [String] {
        return allCases.map { $0.identifier() }
    }
    
    private func locationCheckboxConfig() -> CheckboxConfig {
        let defaultConfig = BodyLocation.checkboxConfig()
        
        return CheckboxConfig(choices: defaultConfig.choices,
                              maxChoices: 1,
                              minChoices: 0,
                              selectedStates: [])
    }
    
}


