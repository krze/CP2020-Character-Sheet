//
//  SkillTableViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/25/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct SkillTableViewModel: MarginCreator {
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio
    let headerHeight: CGFloat = SkillTableConstants.rowHeight
    
    let darkColor = StyleConstants.Color.dark
    let lightColor = StyleConstants.Color.light
    
    let headerFont = StyleConstants.Font.defaultBold
}
