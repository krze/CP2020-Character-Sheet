//
//  EditorCollectionViewModel+Armor.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

extension EditorCollectionViewModel {
    
    static func newArmor() -> EditorCollectionViewModel {
        let mode = EditorMode.free
        let allFields = ArmorField.allCases
        var entryTypes = [Identifier: EntryType]()
        var placeholders = [Identifier: AnyHashable]()
        var descriptions = [Identifier: String]()
        let enforcedOrder = ArmorField.enforcedOrder()
        var customCellWidths = [Identifier: CGFloat]()
        
        allFields.forEach { field in
            entryTypes[field.identifier()] = field.entryType(mode: mode)
            descriptions[field.identifier()] = description(for: field)
            placeholders[field.identifier()] = {
                switch field {
                case .ArmorType:
                    return ArmorType.checkboxConfig()
                case .Locations:
                    return BodyLocation.checkboxConfig()
                case .Zone:
                    return ArmorZone.checkboxConfig()
                case .Price:
                    return "0"
                case .Name, .SP, .EV, .Description:
                    return ""
                }
            }()
            
            customCellWidths[field.identifier()] = {
                switch field {
                case .SP, .EV, .ArmorType:
                    return 1.0 / 3
                default:
                    return nil
                }
            }()
        }
        
        
        return EditorCollectionViewModel(layout: .editorDefault(),
                                         entryTypesForIdentifiers: entryTypes,
                                         placeholdersWithIdentifiers: placeholders,
                                         descriptionsWithIdentifiers: descriptions,
                                         enforcedOrder: enforcedOrder, mode: mode,
                                         cellWidthRatioForIdentifiers: customCellWidths)
        
    }
    
    private static func description(for field: ArmorField) -> String {
        switch field {
        case .ArmorType: return ArmorStrings.armorTypeDescription
        case .Locations: return ArmorStrings.armorLocationDescription
        case .Name: return ArmorStrings.armorNameDescription
        case .Zone: return ArmorStrings.armorZoneDescription
        case .SP: return ArmorStrings.spDescription
        case .EV: return ArmorStrings.evDescription
        case .Description: return EquipmentStrings.description
        case .Price: return EquipmentStrings.price
        }
    }
}
