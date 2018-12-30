//
//  UserEntryView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A custom view that allows for user entry. Provides a label that describes the user input, and
/// an input field that allows user input in various forms, all returnable as a String.
final class UserEntryView: UIView {
    let type: EntryType
    let identifier: String
    
    private let pickerChoices: [String]?
    
    enum EntryType {
        
        /// Raw text entry. Will undergo no validation. Spell checking is not enforced.
        case Text
        
        /// Integer entry. Values entered will be confirmed as an Integer and converted.
        case Integer
        
        /// Picker for an array of Strings.
        case Picker([String])
    }
    
    init(type: EntryType, identifier: String, frame: CGRect) {
        self.type = type
        self.identifier = identifier
        
        switch type {
        case .Picker(let strings):
            pickerChoices = strings
        default:
            pickerChoices = nil
        }
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
