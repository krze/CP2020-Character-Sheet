//
//  DamageModifierViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/25/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct DamageModifierViewModel {
    
    // TODO: Centralized/Localized strings
    let stunSaveText = "Stun Save"
    let bodyTypeModifierText = "BTM"
    
    let stunSaveCellWidthRatio: CGFloat
    let bodyTypeModifierCellWidthRatio: CGFloat
    
    let cellHeightRatio: CGFloat
    let stunSaveLabelHeightRatio: CGFloat
    let bodyTypeModifierLabelHeightRatio: CGFloat
    
    let leftPaddingRatio: CGFloat
    let rightPaddingRatio: CGFloat
    let topPaddingRatio: CGFloat
    let bottomPaddingRatio: CGFloat
    let inbetweenPaddingRatio: CGFloat
    
    init(stunSaveCellWidthRatio: CGFloat, bodyTypeModifierCellWidthRatio: CGFloat, cellHeightRatio: CGFloat, stunSaveLabelHeightRatio: CGFloat, bodyTypeModifierLabelHeightRatio: CGFloat, leftPaddingRatio: CGFloat, rightPaddingRatio: CGFloat, topPaddingRatio: CGFloat, bottomPaddingRatio: CGFloat, inbetweenPaddingRatio: CGFloat) {
        assert(cellHeightRatio <= 1.0,
               "Cannot exceed the height of the collection view cell.")
        assert(bodyTypeModifierCellWidthRatio + stunSaveCellWidthRatio <= 1.0,
               "Cannot exceed the width the collection view cell.")
        
        self.stunSaveCellWidthRatio = stunSaveCellWidthRatio
        self.bodyTypeModifierCellWidthRatio = bodyTypeModifierCellWidthRatio
        self.cellHeightRatio = cellHeightRatio
        self.stunSaveLabelHeightRatio = stunSaveLabelHeightRatio
        self.bodyTypeModifierLabelHeightRatio = bodyTypeModifierLabelHeightRatio
        self.leftPaddingRatio = leftPaddingRatio
        self.rightPaddingRatio = rightPaddingRatio
        self.topPaddingRatio = topPaddingRatio
        self.bottomPaddingRatio = bottomPaddingRatio
        self.inbetweenPaddingRatio = inbetweenPaddingRatio
    }
}
