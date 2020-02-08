//
//  HighlightedSkillViewCellModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Sets up the HighlightedSkillViewCellModel layout
struct HighlightedSkillViewCellModel: MarginCreator {
    
    let cellDescriptionLabelWidthRatio: CGFloat
    let cellDescriptionLabelHeight: CGFloat = ColumnTableConstants.headerHeight
    
    let cellDescriptionLabelText = "Highlighted Skills"
    let cellDescriptionLabelFont = StyleConstants.Font.defaultBold
    let paddingRatio: CGFloat = StyleConstants.Size.textPaddingRatio
    
    let columnLabelWidthRatio = CGFloat(0.15)
    let columnLabelMaxTextSize = CGFloat(16)
    let columnLabelFont = StyleConstants.Font.defaultItalic
    let pointsColumnLabelText = "Points"
    let modifierColumnLabelText = "Mod"
    let totalColumnLabelText = "Total"
    
    let lightColor = StyleConstants.Color.light
    let darkColor = StyleConstants.Color.dark
    let confirmColor = StyleConstants.Color.blue
    let dismissColor = StyleConstants.Color.red
    
}
