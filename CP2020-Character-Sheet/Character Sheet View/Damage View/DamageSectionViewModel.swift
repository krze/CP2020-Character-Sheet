//
//  DamageSectionViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/**
 View properties for individual damage sections within the Damage View
 
 Each damage section looks roughly like this:
 ________________
 | Light        | <---  Wound type label
 | ▢  ▢  ▢  ▢ | <--- Damage cells (default: 4)
 | Stun - 0     | <--- Stun label
 ----------------
 
 */
struct DamageSectionViewModel {
    
    let woundType: WoundType
    let stunType: StunType = StunType.Stun // There is only one type of stun, but it's not considered a wound

    
    /// The proportion of the view taken up by the top section label indicating damage type. This is the top section of the view.
    let woundTypeLabelViewRatio: CGFloat
    
    /// The proportion of the view taken up by the damage cells which track damage points. This is the middle section of the view.
    let damageCellViewRatio: CGFloat
    
    /// The total padding to space around the damage cells. This will be divided by the number of cells
    let damageCellHorizontalPadding: CGFloat
    /// The total padding to space above the damage cells
    let damageCellVerticalPadding: CGFloat
    let damageCellCount: Int
    
    /// The proportion of the view taken up by the stun labe indicating the stun check value. This is the bottom section of the view
    let stunLabelViewRatio: CGFloat
    
    let darkColor: UIColor
    let lightColor: UIColor
    
    /// Creates a view model for the damage cell
    ///
    /// - Parameters:
    ///   - woundType: The type of wound sustained
    ///   - typeRatio: The Y-axis percentage of the view to take up for the wound type label
    ///   - cellRatio: The Y-axis percentage of the view to take up for the damage cells
    ///   - cellHorizontalPaddingSpace: The total amount of padding space you want around the cells
    ///   - cellVerticalPaddingSpace: The total amount of padding space you want around the cells
    ///   - stunRatio: The Y-axis percentage of the view to take up for the stun label
    ///   - darkColor: The dark color for the cell. This should contrast the light color.
    ///   - lightColor: The light color for the cell. This should contrast the dark color.
    init(woundType: WoundType, typeRatio: Double, cellRatio: Double, cellHorizontalPaddingSpace: Double, cellVerticalPaddingSpace: Double, cellCount: Int, stunRatio: Double, darkColor: UIColor, lightColor: UIColor) {
        guard typeRatio + cellRatio + stunRatio == 1.0 else {
            fatalError("Ratios must add up to 1.0")
        }
        
        self.woundType = woundType

        woundTypeLabelViewRatio = CGFloat(typeRatio)
        
        damageCellViewRatio = CGFloat(cellRatio)
        damageCellHorizontalPadding = CGFloat(cellHorizontalPaddingSpace / Double(cellCount + 1)) // 1 extra space for the right side
        damageCellVerticalPadding = CGFloat(cellVerticalPaddingSpace / 2) // Only supports 1 row
        damageCellCount = cellCount

        stunLabelViewRatio = CGFloat(stunRatio)
        
        self.darkColor = darkColor
        self.lightColor = lightColor
    }
    
}
