//
//  EntryType.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/31/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

typealias Identifier = String

/// Configures a user entry field to be set up to accept a certain type of input
enum EntryType {
    
    /// Raw single-line entry. Will undergo no validation. Spell checking is not enforced.
    case Text
    
    /// Raw single-line text entry. Will suggest partial/full matches from array of strings,
    /// but permits free user entry.
    case SuggestedText([String])
    
    /// Raw single-line text entry. Requires the user to select from partial/full matches,
    /// and does not permit the user free entry of text.
    case EnforcedChoiceText([String])
    
    /// Integer entry. Values entered will be confirmed and converted to Integer
    case Integer
    
    /// Raw text entry that needs more than one line. Spell checking is not enforced.
    case LongFormText
    
    /// A field that simply displays text, without allowing the user to edit it
    case Static
    
    /// A collection of "checkbox" style selections, with a configuration that dictates their behavior
    case Checkbox(CheckboxConfig)
    
    /// The standard dice entry field (i.e. 3D6+1). These values will be rolled.
    case DiceRoll
    
    /// Gets the cell reuse ID for use in a collection view. Ordering does not matter for this enum.
    ///
    /// - Returns: Reuse Identifier for use in a collection view
    func cellReuseID() -> String {
        switch self {
        case .Text, .Integer, .SuggestedText, .EnforcedChoiceText, .Static:
            return "ShortFormTextEntryCell"
        case .LongFormText:
            return "LongFormTextEntryCell"
        case .DiceRoll:
            return "DiceRollEntryCell"
        case .Checkbox:
            return CheckboxConfig.editorCellReuseID
        }
    }
    
    /// Gets the height for the cell when used in a collection view
    ///
    /// - Returns: CGFloat height
    func cellHeight() -> CGFloat {
        switch self {
        case .Text, .Integer, .SuggestedText, .EnforcedChoiceText, .Static, .DiceRoll:
            return EditorCollectionViewConstants.headerRowHeight + EditorCollectionViewConstants.editableSingleLineRowHeight
        case .Checkbox(let config):
            let editableRowHeight = EditorCollectionViewConstants.editableSingleLineRowHeight * CGFloat(config.choices.count)
            return EditorCollectionViewConstants.headerRowHeight + editableRowHeight
        case .LongFormText:
            return EditorCollectionViewConstants.headerRowHeight + EditorCollectionViewConstants.editableMultiLineRowHeightMaximum
        }
    }
}

protocol EntryTypeProvider {
    
    /// Provides the identifier for the user entry view
    ///
    /// - Returns: An identifier for user entry view
    func identifier() -> Identifier
    
    /// Provides the entry type for user input
    ///
    /// - Returns: EntryType
    func entryType(mode: EditorMode) -> EntryType
    
    
    /// The order in which the entry views should appear
    ///
    /// - Returns: An array of all identifiers that indicate the ordering of the views
    static func enforcedOrder() -> [String]
    
}
