//
//  UserEntryDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 7/11/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

protocol UserEntryDelegate: class {
    
    /// Signals that the user changed a value
    func userBeganEditing()
    
    /// Signals that cell's entry has finished editing
    ///
    /// - Parameters:
    ///   - identifier: Identifier for the cell
    ///   - value: Text input value for the cell
    ///   - shouldGetSuggestion: Whether this field type would prompt an autofill suggestion
    ///   - resignLastResponder: A closure called if the entry that finished editing was the last responder, and the keyboard needs dismissing
    func entryDidFinishEditing(identifier: Identifier, value: AnyHashable?, shouldGetSuggestion: Bool, resignLastResponder: () -> Void)

}
