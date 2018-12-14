//
//  UserEntryViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/14/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct UserEntryViewModel {
    let labelText: String
    let labelWidthRatio: CGFloat
    var inputWidthRatio: CGFloat {
        return 1.0 - labelWidthRatio
    }
    
    let lightColor: UIColor
    let darkColor: UIColor
    let highlightColor: UIColor
    
    let labelFont: UIFont
    let inputFont: UIFont
    let inputMinimumSize: CGFloat
}
