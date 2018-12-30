//
//  UserEntryViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct UserEntryViewModel: MarginCreator {
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio
    
    var labelText: String?
    let labelWidthRatio: CGFloat
    var inputWidthRatio: CGFloat {
        return 1.0 - labelWidthRatio
    }
    
    let lightColor = StyleConstants.Color.light
    let darkColor = StyleConstants.Color.dark
    let highlightColor = StyleConstants.Color.red
    
    let labelFont: UIFont? = StyleConstants.Font.defaultBold
    let inputFont: UIFont? = StyleConstants.Font.defaultFont
    let inputMinimumSize: CGFloat
    
    init(labelWidthRatio: CGFloat, inputMinimumSize: CGFloat = StyleConstants.Font.minimumSize) {
        self.labelWidthRatio = labelWidthRatio
        self.labelText = nil
        self.inputMinimumSize = inputMinimumSize
    }
}
