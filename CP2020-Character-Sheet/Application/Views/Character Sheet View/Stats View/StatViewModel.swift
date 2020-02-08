//
//  StatViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/9/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct StatViewModel: MarginCreator {
    let stat: Stat
    let statNameFont = StyleConstants.Font.defaultBold
    
    /// The full value of the stat
    let baseValue: Int
    let statValueRatio: CGFloat
    let statValueFont = StyleConstants.Font.defaultFont
    let statValueBorder: CGFloat
    
    /// The current value of the stat, if it's a stat that can be affected by other factors (i.e. Empathy from Humanity Loss)
    let statCurrentValue: Int?
    
    /// Padding for the interior of the view, to ensure text doesnt go to the edge, for each edge
    let paddingRatio: CGFloat
    let lightColor: UIColor
    let darkColor: UIColor
    
    /// Color for a beneficial stat effect
    let goodColor: UIColor
    /// Color for a detremental stat effect
    let badColor: UIColor
    
    static func model(for stat: Stat, baseValue: Int, currentValue: Int?) -> StatViewModel {
        return StatViewModel(stat: stat,
                             baseValue: baseValue,
                             statValueRatio: 0.25,
                             statValueBorder: StyleConstants.Size.borderWidth,
                             statCurrentValue: currentValue,
                             paddingRatio: StyleConstants.Size.textPaddingRatio,
                             lightColor: StyleConstants.Color.light,
                             darkColor: StyleConstants.Color.dark,
                             goodColor: StyleConstants.Color.blue,
                             badColor: StyleConstants.Color.red)
    }
}
