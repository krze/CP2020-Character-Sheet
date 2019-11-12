//
//  EditorCollectionViewModel+Stats.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 8/20/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// An alias for a dictionary lat lists each editable stat with their base value for passing to/from an editor
typealias StatsWithBaseValues = [Stat: Int]

extension EditorCollectionViewModel {
    
    static func make(with stats: StatsWithBaseValues, humanityLossPlaceholder: String) -> EditorCollectionViewModel {
        var entryTypesForIdentifiers = [Identifier: EntryType]()
        var placeholdersWithIdentifiers = [Identifier: String]()
        var descriptionsWithIdentifiers = [Identifier: String]()
        
        stats.forEach { stat, value in
            let identifier = stat.identifier()
            entryTypesForIdentifiers[identifier] = stat.entryType(mode: .free)
            placeholdersWithIdentifiers[identifier] = {
                if Rules.Stats.validPointRange.contains(value) {
                    return String(value)
                }
                
                return String("")
            }()
            descriptionsWithIdentifiers[identifier] = description(for: stat)
        }
        
        let humanityLoss = StatsStrings.humanityLossIdentifier
        entryTypesForIdentifiers[humanityLoss] = .Integer
        placeholdersWithIdentifiers[humanityLoss] = humanityLossPlaceholder
        descriptionsWithIdentifiers[humanityLoss] = StatsStrings.humanityLossDescription
        var enforcedOrder = Stat.enforcedOrder()
        
        enforcedOrder.append(humanityLoss)
        
        return EditorCollectionViewModel(layout: .editorDefault(), entryTypesForIdentifiers: entryTypesForIdentifiers, placeholdersWithIdentifiers: placeholdersWithIdentifiers, descriptionsWithIdentifiers: descriptionsWithIdentifiers, enforcedOrder: enforcedOrder, mode: .free)
    }
    
    private static func description(for stat: Stat) -> String {
        switch stat {
        case .Body:
            return StatsStrings.bodyDescription
        case .Attractiveness:
            return StatsStrings.attractivenessDescription
        case .Cool:
            return StatsStrings.coolDescription
        case .Empathy:
            return StatsStrings.empathyDescription
        case .Intelligence:
            return StatsStrings.intelligenceDescription
        case .Luck:
            return StatsStrings.luckDescription
        case .MovementAllowance:
            return StatsStrings.movementDescription
        case .Reflex:
            return StatsStrings.reflexDescription
        case .Tech:
            return StatsStrings.techDescription
        case .Reputation:
            return StatsStrings.reputationDescription
        default:
            return "No description available. You shouldn't be able to edit this!"
        }
    }

}
