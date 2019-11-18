//
//  UserEntryValidating.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/6/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

protocol UserEntryValidating {
    
    var suggestedMatches: [String] { get }
    var identifier: Identifier { get }
    var isValid: Bool { get }
    var currentValue: AnyHashable? { get }
    
    var delegate: UserEntryDelegate? { get set }
    
    /// Makes the user entry field the first responder. Returns true if resigned successfully.
    func makeFirstResponder() -> Bool
    
    /// Used to indicate save was called
    func saveWasCalled()
    
    /// Replaces the editable field's content with the given string
    /// - Parameter value: The new value
    func replaceWithSuggestedMatch(_ value: AnyHashable)
    
    /// Forces a warning to appear
    func forceWarning()
    
}
