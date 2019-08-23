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
    func valuesFromEditorDidChange(_ values: [Identifier: String], validationCompletion completion: @escaping (ValidatedEditorResult) -> Void)
    
}

/// An object containing the results from an editor, validated by the model. If the result was successful,
/// a Validated will be returned, which is merely a placeholder for now. In future iterations, editors may
/// utilize a more complex success object to convey information to the user. For example, if editing the
/// player's damage levls by using an attack roll, the success condition may return the results of the damage
/// to the player textualized or visualized.
///
/// If the results were not valid at all, an error is returned containing a user-facing message. It's up to the
/// editor to display the message.
typealias ValidatedEditorResult = Result<Validated, Violation>

enum Validated {
    case valid
}
