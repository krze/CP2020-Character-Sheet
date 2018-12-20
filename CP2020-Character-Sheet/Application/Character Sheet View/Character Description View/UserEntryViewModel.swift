//
//  UserEntryViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/14/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct UserEntryViewModel: MarginCreator {
    let paddingRatio: CGFloat
    
    let labelText: String
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
}
