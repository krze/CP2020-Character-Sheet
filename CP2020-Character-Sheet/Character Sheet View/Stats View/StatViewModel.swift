//
//  StatViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/9/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct StatViewModel {
    let stat: Stat
    let statNameFont = StyleConstants.Font.defaultBold
    
    /// The full value of the stat
    let statValue: Int
    let statValueRatio: CGFloat
    let statValueFont = StyleConstants.Font.defaultFont
    let statValueBorder: CGFloat
    
    /// The current value of the stat, if it's a stat that can be affected by other factors (i.e. Empathy from Humanity Loss)
    let statCurrentValue: Int?
    
    /// Padding for the interior of the view, to ensure text doesnt go to the edge, for each edge
    let paddingRatio: CGFloat
    let lightColor: UIColor
    let darkColor: UIColor
    let highlightColor: UIColor
    
    static func model(for stat: Stat, baseValue: Int, currentValue: Int?) -> StatViewModel {
        let valueRatio: CGFloat = {
            return stat.hasBaseState() ? 0.5 : 0.25
        }()

        return StatViewModel(stat: stat, statValue: baseValue, statValueRatio: valueRatio, statValueBorder: 2.0, statCurrentValue: currentValue, paddingRatio: 0.05, lightColor: StyleConstants.Color.light, darkColor: StyleConstants.Color.dark, highlightColor: StyleConstants.Color.red)
    }
}
