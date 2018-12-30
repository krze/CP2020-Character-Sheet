//
//  PopoverEditorViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct PopoverEditorViewModel: PopoverViewFrameProvider, EditorViewModel, MarginCreator {
    
    typealias RowType = UserEntryView.EntryType
    let numberOfRows: Int
    let rowsWithIdentifiers: [String: RowType]
    let numberOfColumns: Int
    let labelWidthRatio: CGFloat
    
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio
    let minimumRowHeight: CGFloat = StyleConstants.SizeConstants.editorRowHeight
    let popoverYSpacingRatio: CGFloat = StyleConstants.SizeConstants.popoverTopPaddingRatio
    let popoverHeightRatio: CGFloat = StyleConstants.SizeConstants.popoverViewHeightRatio
    
    var minimumHeightForAllRows: CGFloat {
        return CGFloat(requiredRowCount) * minimumRowHeight
    }
    
    private let requiredRowCount: Int
    
    init(numberOfColumns: Int = 1, numberOfRows: Int, rowsWithIdentifiers: [String: RowType], labelWidthRatio: CGFloat) {
        self.numberOfColumns = numberOfColumns
        self.numberOfRows = numberOfRows
        self.labelWidthRatio = labelWidthRatio
        
        requiredRowCount = {
            let extraRowForRemainder = rowsWithIdentifiers.count % numberOfRows > 0
            let rowsNeeded = rowsWithIdentifiers.count / numberOfRows + (extraRowForRemainder ? 1 : 0)
            
            return rowsNeeded
        }()
        
        if requiredRowCount != numberOfRows {
            fatalError("The number of rows must account for the amount of space necessary to accomodate the rows.")
        }
        
        self.rowsWithIdentifiers = rowsWithIdentifiers
    }
}
