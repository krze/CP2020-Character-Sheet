//
//  UserEntryDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 7/11/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

protocol UserEntryDelegate: class {
    
    func entryDidFinishEditing(identifier: Identifier, value: String?)
    
    func fieldValidityChanged(identifier: String, newValue: Bool)
    
}
