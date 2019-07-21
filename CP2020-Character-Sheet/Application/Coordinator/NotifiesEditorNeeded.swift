//
//  NotifiesEditorNeeded.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/31/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Objects adhering to this protocol are expected to send notifications that an editor view needs to display.
/// TODO: Delete this with the old editor
protocol NotifiesEditorNeeded {
    
    /// Used to initiate a notification an EditorViewController needs to be shown.
    ///
    /// - Parameter identifiersWithPlaceholders: The identifiers for each editor field, and the placeholder values for each field.
    func editorRequested(currentFieldStates: [CurrentFieldState], enforcedOrder: [String], sourceView: UIView)
    
}
