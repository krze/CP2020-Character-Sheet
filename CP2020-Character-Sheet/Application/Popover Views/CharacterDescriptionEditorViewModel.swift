//
//  CharacterDescriptionEditorViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct CharacterDescriptionEditorViewModel: PopoverViewFrameProvider, EditorViewModel, MarginCreator {
    
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio
    let numberOfRows: Int = 3
    let minimumRowHeight: CGFloat = StyleConstants.SizeConstants.editorRowHeight
    let popoverYSpacingRatio: CGFloat = StyleConstants.SizeConstants.popoverTopPaddingRatio
    let popoverHeightRatio: CGFloat = StyleConstants.SizeConstants.popoverViewHeightRatio
    
}
