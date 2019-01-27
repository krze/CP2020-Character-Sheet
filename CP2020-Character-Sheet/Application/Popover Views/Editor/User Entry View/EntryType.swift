//
//  EntryType.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/31/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

typealias Identifier = String

enum EntryType {
    
    /// Raw text entry. Will undergo no validation. Spell checking is not enforced.
    case Text
    
    /// Integer entry. Values entered will be confirmed as an Integer and converted.
    case Integer
    
    /// Picker for an array of Strings.
    case Picker([String])
    
    /// Raw text entry that needs more than one line. Spell checking is not enforced.
    case LongFormText
    
    /// Gets the cell reuse ID for use in a collection view. Ordering does not matter for this enum.
    ///
    /// - Returns: Reuse Identifier for use in a collection view
    func cellReuseID() -> String {
        switch self {
        case .Text:
            return "TextEntryCell"
        case .Integer:
            return "IntegerEntryCell"
        case .LongFormText:
            return "LongFormTextEntryCell"
        case .Picker:
            return "PickerEntryCell"
        }
    }
    
    /// Gets the height for the cell when used in a collection view
    ///
    /// - Returns: CGFloat height
    func cellHeight() -> CGFloat {
        switch self {
        case .Text, .Integer, .Picker:
            return EditorCollectionViewConstants.headerRowHeight + EditorCollectionViewConstants.editableSingleLineRowHeight
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
    func entryType() -> EntryType
    
    /// The order in which the entry views should appear
    ///
    /// - Returns: An array of all identifiers that indicate the ordering of the views
    static func enforcedOrder() -> [String]
    
}
