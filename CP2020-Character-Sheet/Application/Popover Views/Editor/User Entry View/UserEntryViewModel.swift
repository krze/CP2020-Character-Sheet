//
//  UserEntryViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct UserEntryViewModel: MarginCreator {
    
    let type: EntryType
    let labelText: String
    let labelWidthRatio: CGFloat
    let inputMinimumSize: CGFloat
    let placeholder: String

    var inputWidthRatio: CGFloat {
        return 1.0 - labelWidthRatio
    }
    
    let lightColor = StyleConstants.Color.light
    let darkColor = StyleConstants.Color.dark
    let confirmColor = StyleConstants.Color.blue
    
    let labelFont: UIFont? = StyleConstants.Font.defaultBold
    let inputFont: UIFont? = StyleConstants.Font.defaultFont
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio

    init(type: EntryType,
         labelText: String,
         labelWidthRatio: CGFloat,
         placeholder: String,
         inputMinimumSize: CGFloat = StyleConstants.Font.minimumSize) {
        self.type = type
        self.labelWidthRatio = labelWidthRatio
        self.labelText = labelText
        self.inputMinimumSize = inputMinimumSize
        self.placeholder = placeholder
    }
}
