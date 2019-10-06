//
//  UserEntryDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 7/11/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

protocol UserEntryDelegate: class {
    
    /// Signals that cell's entry has finished editing
    ///
    /// - Parameters:
    ///   - identifier: Identifier for the cell
    ///   - value: Text input value for the cell
    ///   - resignLastResponder: A closure called if the entry that finished editing was the last responder, and the keyboard needs dismissing
    func entryDidFinishEditing(identifier: Identifier, value: String?, resignLastResponder: () -> Void)
    
    /// Signals that the cell has changed from one valid state to another
    ///
    /// - Parameters:
    ///   - identifier: Identifier for the cell
    ///   - newValue: The new state of validity
    func fieldValidityChanged(identifier: String, newValue: Bool)
    
}
