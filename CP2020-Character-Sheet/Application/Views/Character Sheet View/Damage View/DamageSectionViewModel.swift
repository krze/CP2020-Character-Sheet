//
//  DamageSectionViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/**
 Initial view properties for individual damage sections within the DamageView
 
 Each damage section looks roughly like this:
 ________________
 | Light        | <---  Wound type label
 | ▢  ▢  ▢  ▢ | <--- Damage cells (default: 4)
 | Stun - 0     | <--- Stun label
 ----------------
 
 */
struct DamageSectionViewModel {
    
    let woundType: WoundType
    let stunType: SaveRollType = .Stun // There is only one type of stun, but it's not considered a wound

    
    /// The proportion of the view taken up by the top section label indicating damage type. This is the top section of the view.
    let woundTypeLabelViewRatio: CGFloat
    
    let totalDamage: Int
    
    /// The proportion of the view taken up by the damage cells which track damage points. This is the middle section of the view.
    let damageCellViewRatio: CGFloat
    
    /// The total padding to space around the damage cells. This will be divided by the number of cells
    let damageCellHorizontalPadding: CGFloat
    let damageCellTotalHorizontalPadding: CGFloat
    /// The total padding to space above the damage cells
    let damageCellVerticalPadding: CGFloat
    let damageCellTotalVerticalPadding: CGFloat
    let damageCellCount: Int
    let damageCellBorderThickness: CGFloat
    
    /// The proportion of the view taken up by the stun labe indicating the stun check value. This is the bottom section of the view
    let stunLabelViewRatio: CGFloat
    
    let darkColor: UIColor
    let lightColor: UIColor
    
    let startingDamageCellNumber: Int
    
    let stunCount: Int
    let mortalCount: Int?

    /// Creates a view model for the damage cell
    ///
    /// - Parameters:
    ///   - startingDamageCellNumber: The number correlating with the starting damage cell, out of total damage points for the character (i.e. if this was the fifth damage cell out of 40 total damage, this would be 5)
    ///   - totalDamage: The total number of damage for the character (default 40)
    ///   - woundType: The type of wound sustained, displayed in the top track
    ///   - typeRatio: The Y-axis percentage of the view to take up for the wound type label
    ///   - cellRatio: The Y-axis percentage of the view to take up for the damage cells
    ///   - cellHorizontalPaddingSpace: The total amount of padding space you want around the damage cells
    ///   - cellVerticalPaddingSpace: The total amount of padding space you want around the damagecells
    ///   - cellCount: The total number of damage cells for this section
    ///   - stunRatio: The Y-axis percentage of the view to take up for the stun label
    ///   - darkColor: The dark color for the cell. This should contrast the light color.
    ///   - lightColor: The light color for the cell. This should contrast the dark color.
    init(startingDamageCellNumber: Int,
         totalDamage: Int,
         woundType: WoundType,
         typeRatio: CGFloat,
         cellRatio: CGFloat,
         cellHorizontalPaddingSpace: CGFloat,
         cellVerticalPaddingSpace: CGFloat,
         cellBorderThickness: CGFloat,
         cellCount: Int,
         stunRatio: CGFloat,
         darkColor: UIColor,
         lightColor: UIColor) {
        guard typeRatio + cellRatio + stunRatio <= 1.0 else {
            fatalError("Ratios must not exceed 1.0")
        }
        
        self.startingDamageCellNumber = startingDamageCellNumber
        
        self.woundType = woundType

        woundTypeLabelViewRatio = typeRatio
        
        damageCellViewRatio = cellRatio
        damageCellHorizontalPadding = cellHorizontalPaddingSpace / CGFloat(cellCount + 1) // 1 extra space for the right side
        damageCellTotalHorizontalPadding = cellHorizontalPaddingSpace
        damageCellVerticalPadding = cellVerticalPaddingSpace / 2 // Only supports 1 row
        damageCellTotalVerticalPadding = cellVerticalPaddingSpace
        damageCellBorderThickness = cellBorderThickness
        damageCellCount = cellCount

        stunLabelViewRatio = stunRatio
        
        self.darkColor = darkColor
        self.lightColor = lightColor
        
        stunCount = Int((Double(startingDamageCellNumber) / Double(totalDamage)) * 10)
        
        if woundType == .Mortal {
            // Sections have an "index" value, where the first section is 0, it happens to correlate
            // with the stunCount.
            let thisSegmentIndex = stunCount
            
            // Mortal wound types start at "Mortal 0", after all the non-mortal wound types which occupy
            // the initial indices BEFORE "Mortal 0". i.e. Light is index 0 ... Critical is index 2, the first
            // Mortal wound be index 3, so if this is tagged as a Mortal wound, we must shift -3 (indices 0-2)
            // to get Mortal 0
            mortalCount = thisSegmentIndex - WoundType.allCases.filter({ $0 != .Mortal }).count
        }
        else {
            mortalCount = nil
        }
        
        self.totalDamage = totalDamage
    }
    
    /// Constructs a view model, iterating off the current model's properties.
    ///
    /// - Parameter woundType: Wound type for the new view model
    /// - Returns: A new view model ready to be placed adjacent to the previous
    func constructNextModel(for woundType: WoundType) -> DamageSectionViewModel {
        return DamageSectionViewModel(startingDamageCellNumber: startingDamageCellNumber + damageCellCount,
                                      totalDamage: totalDamage,
                                      woundType: woundType,
                                      typeRatio: woundTypeLabelViewRatio,
                                      cellRatio: damageCellViewRatio,
                                      cellHorizontalPaddingSpace: damageCellTotalHorizontalPadding,
                                      cellVerticalPaddingSpace: damageCellTotalVerticalPadding,
                                      cellBorderThickness: damageCellBorderThickness,
                                      cellCount: damageCellCount,
                                      stunRatio: stunLabelViewRatio,
                                      darkColor: darkColor,
                                      lightColor: lightColor)
    }
    
}
