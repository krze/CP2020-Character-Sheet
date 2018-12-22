//
//  SkillTableViewCellModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/21/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct SkillTableViewCellModel: MarginCreator {
    
    let nameFont = StyleConstants.Font.defaultFont
    let numberFont = StyleConstants.Font.defaultFont
    let totalFont = StyleConstants.Font.defaultBold
    
    let fontSize = CGFloat(14)
    
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio
}
