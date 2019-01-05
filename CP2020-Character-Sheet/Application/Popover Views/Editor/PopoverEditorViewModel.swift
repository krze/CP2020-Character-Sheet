//
//  PopoverEditorViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct PopoverEditorViewModel: PopoverViewFrameProvider, EditorViewModel, MarginCreator {
    
    /// The number of editable rows
    let numberOfRows: Int
    
    /// A representation of editable cells with their identifiers
    let entryTypesForIdentifiers: [Identifier: EntryType]
    
    /// A representation of the placeholder values for the entry views
    let placeholdersWithIdentifiers: [Identifier: String]?
    
    /// An array representing the order of the editable cells
    let enforcedOrder: [Identifier]
    
    /// The number of columns in the view
    let numberOfColumns: Int
    
    let includeSpaceForButtons: Bool
    
    /// The width of the label for each entry view. The width of the entry field next to the label will
    /// use the space remaining after the label. (i.e. if the labelWidthRatio is 0.3 (or 30% of the entry view),
    /// the entry field will have a value of 0.7)
    let labelWidthRatio: CGFloat
    
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio
    let minimumRowHeight: CGFloat = StyleConstants.SizeConstants.editorRowHeight
    let popoverYSpacingRatio: CGFloat = StyleConstants.SizeConstants.popoverTopPaddingRatio
    let popoverHeightRatio: CGFloat = StyleConstants.SizeConstants.popoverViewHeightRatio
    
    var minimumHeightForAllRows: CGFloat {
        return CGFloat(numberOfRows) * minimumRowHeight
    }
    
    /// Constructs a view model for a popover Editor view
    ///
    /// - Parameters:
    ///   - numberOfColumns: The number of columns that will contain the user entry fields
    ///   - numberOfRows: The number of rows that will contain the user entry fields
    ///   - entryTypesForIdentifiers: An dictionary of identifiers associated with the entry type for each field
    ///   - placeholdersWithIdentifiers: An dictionary of identifiers associated with the placehodler value for each field
    ///   - enforcedOrder: A sorted array of Identifiers that dictates the order of the fields, from top to bottom. Multiple
    ///                         columns are filled top to bottom, moving left to right as each column fills.
    ///   - labelWidthRatio: The width of the label for each user entry view. The width of the entry field next to the label will
    ///                         use the space remaining after the label. (i.e. if the labelWidthRatio is 0.3 (or 30% of the entry
    ///                         view), the entry field will have a value of 0.7)
    init(numberOfColumns: Int = 1,
         numberOfRows: Int,
         entryTypesForIdentifiers: [Identifier: EntryType],
         placeholdersWithIdentifiers: [Identifier: String]?,
         enforcedOrder: [Identifier],
         labelWidthRatio: CGFloat,
         includeSpaceForButtons: Bool) {
        self.includeSpaceForButtons = includeSpaceForButtons
        self.numberOfColumns = numberOfColumns
        self.numberOfRows = numberOfRows
        self.labelWidthRatio = labelWidthRatio

        let enoughSpace = numberOfColumns * numberOfRows >= entryTypesForIdentifiers.count
        
        if !enoughSpace {
            fatalError("The number of rows must account for the amount of space necessary to accomodate the rows.")
        }
        
        self.entryTypesForIdentifiers = entryTypesForIdentifiers
        self.placeholdersWithIdentifiers = placeholdersWithIdentifiers
        self.enforcedOrder = enforcedOrder
    }
}
