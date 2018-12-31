//
//  EntryType.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/31/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit


enum EntryType {
    
    /// Raw text entry. Will undergo no validation. Spell checking is not enforced.
    case Text
    
    /// Integer entry. Values entered will be confirmed as an Integer and converted.
    case Integer
    
    /// Picker for an array of Strings.
    case Picker([String])
}

protocol EntryTypeProvider {
    
    /// Provides the identifier for the user entry view
    ///
    /// - Returns: An identifier for user entry view
    func identifier() -> String
    
    /// Provides the entry type for user input
    ///
    /// - Returns: EntryType
    func entryType() -> EntryType
    
}
