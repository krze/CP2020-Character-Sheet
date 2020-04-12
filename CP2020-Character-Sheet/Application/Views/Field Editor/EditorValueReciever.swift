//
//  EditorValueReciever.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A delegate that handles when the user input is returned from an editor
protocol EditorValueReciever: class {
    
    /// Indicates that the editor values changed, used to signal the model under editing is about to receive
    /// new values from the editor.
    ///
    /// - Parameters:
    ///   - values: The identifiers and their values from the UserEntryCollectionViewCells in the editor
    ///   - validationCompletion: The completion handler called by the model to indicate that the results were verified and came back as valid or invalid
    func valuesFromEditorDidChange(_ values: [Identifier: AnyHashable], validationCompletion completion: @escaping ValidatedCompletion)
    
    /// Forces a refresh on the receiver of the data
    func refreshData()
    
    /// Brings up the best match for an autofill suggestion for the whole editor in order to fill it out based on closest match.
    /// - Parameter identifier: Identifier for the field that needs a suggestion
    /// - Parameter value: The value for the field
    /// - returns: A value to fill out the whole editor, if any
    func autofillSuggestion(for identifier: Identifier, value: AnyHashable) -> [Identifier: AnyHashable]?
    
}

/// An object containing the results of changes validated by the model. If the result was successful,
/// a Validated will be returned, with a completion block that needs to be called.
///
/// If the results were not valid at all, an error is returned containing a user-facing message. It's up to the
/// reciever to display the message.
typealias ValidatedResult = Result<Validated, Violation>

/// A completion block that takes a result from the validator and returns nothing
typealias ValidatedCompletion = (ValidatedResult) -> Void

enum Validated {
    case valid(completion: () -> Void)
}

func defaultCompletion(_ result: ValidatedResult) -> Void {
    switch result {
    case .success(let validation):
        switch validation {
        case .valid(let completion):
            completion()
        }
    case .failure(let violation):
        print(violation.helpText())
    }

}
