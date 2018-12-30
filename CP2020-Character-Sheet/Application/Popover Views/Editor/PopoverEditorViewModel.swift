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
    let rowTypes: [RowType]
    
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio
    let minimumRowHeight: CGFloat = StyleConstants.SizeConstants.editorRowHeight
    let popoverYSpacingRatio: CGFloat = StyleConstants.SizeConstants.popoverTopPaddingRatio
    let popoverHeightRatio: CGFloat = StyleConstants.SizeConstants.popoverViewHeightRatio
    
    init(numberOfRows: Int, rowTypes: [RowType]) {
        self.numberOfRows = numberOfRows
        
        // TODO: Fix this for columns
        if rowTypes.count != numberOfRows {
            fatalError("The number of rows must equal the count of rowTypes")
        }
        
        self.rowTypes = rowTypes
    }
}
