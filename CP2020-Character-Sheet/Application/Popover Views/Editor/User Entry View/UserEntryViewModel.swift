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
    let identifierText: String
    let descriptionText: String
    let placeholder: String

    let inputWidthRatio: CGFloat
    let identifierWidthRatio: CGFloat
    
    let inputMinimumSize: CGFloat
    
    /// Indicates whether the entry should be stacked, rather than presented side by side
    let stacked: Bool
    
    let headerHeight: CGFloat
    let descriptionHeight: CGFloat
    let inputHeight: CGFloat
    
    var stackHeight: CGFloat {
        return headerHeight + descriptionHeight + inputHeight
    }
    
    let lightColor = StyleConstants.Color.light
    let darkColor = StyleConstants.Color.dark
    let confirmColor = StyleConstants.Color.blue
    
    let labelFont: UIFont? = StyleConstants.Font.defaultBold
    let descriptionFont: UIFont? = StyleConstants.Font.light
    let inputFont: UIFont? = StyleConstants.Font.defaultFont
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio

    /// Creates a side-by-side user entry view
    ///
    /// - Parameters:
    ///   - type: EntryType
    ///   - identifierText: The identifier used to title the field
    ///   - identifierWidthRatio: The width of the identifier label. The remaining space will be used for the user entry field.
    ///   - placeholder: The placeholder string for the input field
    ///   - inputMinimumSize: The minimum font size for user input
    init(type: EntryType,
         identifierText: String,
         identifierWidthRatio: CGFloat,
         placeholder: String,
         inputMinimumSize: CGFloat = StyleConstants.Font.minimumSize) {
        self.type = type
        self.identifierWidthRatio = identifierWidthRatio
        self.identifierText = identifierText
        self.inputMinimumSize = inputMinimumSize
        self.placeholder = placeholder
        self.descriptionText = ""
        self.inputWidthRatio = 1.0 - identifierWidthRatio
        self.stacked = false
        self.headerHeight = 0
        self.descriptionHeight = 0
        self.inputHeight = 0
    }
    
    /// Creates a model for a full-width UserEntryView, assuming it will be stacked.
    ///
    /// - Parameters:
    ///   - type: The entry type
    ///   - headerText: The text going in the header. Use the identifier for this field.
    ///   - descriptionText: The text going in the helper description.
    ///   - placeholderText: The placeholder value for the user entry view
    ///   - inputMinimumSize: The minimum text size for user input
    init(type: EntryType,
         headerText: String,
         descriptionText: String,
         placeholderText: String,
         inputMinimumSize: CGFloat = StyleConstants.Font.minimumSize) {
        self.type = type
        self.identifierText = headerText
        self.descriptionText = descriptionText
        self.placeholder = placeholderText
        self.inputWidthRatio = 1.0
        self.identifierWidthRatio = 1.0
        self.inputMinimumSize = inputMinimumSize
        self.stacked = true
        self.headerHeight = EditableScrollViewModelConstants.headerRowHeight
        self.descriptionHeight = EditableScrollViewModelConstants.descriptionRowHeight
        self.inputHeight = {
            switch type {
            case .LongFormText:
                return EditableScrollViewModelConstants.editableMultiLineRowHeightMaximum
            default:
                return EditableScrollViewModelConstants.editableSingleLineRowHeight
            }
        }()
    }
    
}
