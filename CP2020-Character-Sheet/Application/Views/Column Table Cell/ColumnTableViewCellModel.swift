//
//  ColumnTableViewCellModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/21/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct ColumnTableViewCellModel: MarginCreator {
    
    let nameFont = StyleConstants.Font.defaultFont
    let columnFontRegular = StyleConstants.Font.defaultFont
    let columnFontBold = StyleConstants.Font.defaultBold
    
    let fontSize = CGFloat(16)
    
    let paddingRatio: CGFloat = StyleConstants.Size.textPaddingRatio
}
