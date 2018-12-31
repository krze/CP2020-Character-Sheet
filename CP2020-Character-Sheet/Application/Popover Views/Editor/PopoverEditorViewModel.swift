//
//  PopoverEditorViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct PopoverEditorViewModel: PopoverViewFrameProvider, EditorViewModel, MarginCreator {
    
    let numberOfRows: Int
    let rowsWithIdentifiers: [String: EntryType]
    let placeholdersWithIdentifiers: [String: String]?
    let numberOfColumns: Int
    let labelWidthRatio: CGFloat
    
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio
    let minimumRowHeight: CGFloat = StyleConstants.SizeConstants.editorRowHeight
    let popoverYSpacingRatio: CGFloat = StyleConstants.SizeConstants.popoverTopPaddingRatio
    let popoverHeightRatio: CGFloat = StyleConstants.SizeConstants.popoverViewHeightRatio
    
    var minimumHeightForAllRows: CGFloat {
        return CGFloat(numberOfRows) * minimumRowHeight
    }
    
    init(numberOfColumns: Int = 1,
         numberOfRows: Int,
         rowsWithIdentifiers: [String: EntryType],
         placeholdersWithIdentifiers: [String: String]?,
         labelWidthRatio: CGFloat) {
        self.numberOfColumns = numberOfColumns
        self.numberOfRows = numberOfRows
        self.labelWidthRatio = labelWidthRatio

        let enoughSpace = numberOfColumns * numberOfRows >= rowsWithIdentifiers.count
        
        if !enoughSpace {
            fatalError("The number of rows must account for the amount of space necessary to accomodate the rows.")
        }
        
        self.rowsWithIdentifiers = rowsWithIdentifiers
        self.placeholdersWithIdentifiers = placeholdersWithIdentifiers
    }
}
