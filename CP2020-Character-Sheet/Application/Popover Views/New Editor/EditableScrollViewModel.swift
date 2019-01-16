//
//  EditableScrollViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/15/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

struct EditableScrollViewModel: StackedEntryViewModel, MarginCreator {
    

    let entryTypesForIdentifiers: [Identifier : EntryType]
    
    let placeholdersWithIdentifiers: [Identifier : String]?
    let descriptionsWithIdentifiers: [Identifier : String]?

    let enforcedOrder: [Identifier]
    
    let labelWidthRatio: CGFloat = 1.0
    
    let numberOfColumns: Int = 1 // TODO: Resolve the issue of multiple columns
    
    let numberOfRows: Int
    
    let includeSpaceForButtons: Bool
    
    var minimumHeightForAllRows: CGFloat {
        var height: CGFloat = 0
        entryTypesForIdentifiers.forEach { _, entryType in
            switch entryType {
            case .LongFormText:
                height += EditableScrollViewModelConstants.editableMultiLineRowHeightMaximum
            default:
                height += EditableScrollViewModelConstants.editableSingleLineRowHeight
            }
        }
        
        return height
    }
    
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio
    
    let lightColor = StyleConstants.Color.light
    let darkColor = StyleConstants.Color.dark
    let blueColor = StyleConstants.Color.blue
    let redColor = StyleConstants.Color.red
    
}

struct EditableScrollViewModelConstants {
    
    static let headerRowHeight: CGFloat = 32
    static let descriptionRowHeight: CGFloat = 32
    static let editableSingleLineRowHeight: CGFloat = 44
    static let editableMultiLineRowHeightMaximum: CGFloat = 132
    
}
