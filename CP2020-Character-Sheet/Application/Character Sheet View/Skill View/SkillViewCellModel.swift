//
// SkillViewCellModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Sets up the SkillViewCell layout
struct SkillViewCellModel {
    
    let cellDescriptionLabelWidthRatio: CGFloat
    let cellDescriptionLabelHeight: CGFloat = SkillTableConstants.rowHeight
    
    let cellDescriptionLabelText = "HIGHLIGHTED SKILLS"
    let cellDescriptionLabelFont = StyleConstants.Font.defaultBold
    let cellDescriptionLabelPadding = StyleConstants.SizeConstants.textPaddingRatio
    
    let lightColor = StyleConstants.Color.light
    let darkColor = StyleConstants.Color.dark
    let highlightColor = StyleConstants.Color.red
    
}
