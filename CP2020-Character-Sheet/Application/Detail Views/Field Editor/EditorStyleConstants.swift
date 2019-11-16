//
//  EditorStyleConstants.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

struct EditorStyleConstants: MarginCreator {
    
    let paddingRatio: CGFloat = 0.025
    
    let lightColor = StyleConstants.Color.light
    let darkColor = StyleConstants.Color.dark
    let grayColor = StyleConstants.Color.gray
    let blueColor = StyleConstants.Color.blue
    let redColor = StyleConstants.Color.red

    let fadedFillColorAlpha: CGFloat = 0.5
    
    let labelFont = StyleConstants.Font.defaultBold
    let inputFont = StyleConstants.Font.defaultFont
    
    let headerHeight: CGFloat = EditorCollectionViewConstants.headerRowHeight
    let entryHeight: CGFloat = EditorCollectionViewConstants.editableSingleLineRowHeight
    let longFormEntryHeight: CGFloat = EditorCollectionViewConstants.editableMultiLineRowHeightMaximum
}
