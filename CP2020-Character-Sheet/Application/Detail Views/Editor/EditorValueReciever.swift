//
//  EditorValueReciever.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A delegate that handles when the user input is returned from an editor
protocol EditorValueReciever {
    
    func valuesFromEditorDidChange(_ values: [Identifier: String])
    
}
