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
    let placeholderValue = "0"
    
    let cellWidthRatio: CGFloat
    let cellHeightRatio: CGFloat
    
    let labelHeightRatio: CGFloat
    
    let leftPaddingRatio: CGFloat
    let rightPaddingRatio: CGFloat
    let topPaddingRatio: CGFloat
    let bottomPaddingRatio: CGFloat
    let inbetweenPaddingRatio: CGFloat
    
    init(cellWidthRatio: CGFloat, cellHeightRatio: CGFloat, labelHeightRatio: CGFloat, leftPaddingRatio: CGFloat, rightPaddingRatio: CGFloat, topPaddingRatio: CGFloat, bottomPaddingRatio: CGFloat, inbetweenPaddingRatio: CGFloat) {
        
        self.cellWidthRatio = cellWidthRatio
        self.cellHeightRatio = cellHeightRatio
        self.labelHeightRatio = labelHeightRatio
        self.leftPaddingRatio = leftPaddingRatio
        self.rightPaddingRatio = rightPaddingRatio
        self.topPaddingRatio = topPaddingRatio
        self.bottomPaddingRatio = bottomPaddingRatio
        self.inbetweenPaddingRatio = inbetweenPaddingRatio
    }
}
