//
//  UserEntryCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

typealias UserEntryCollectionViewCell = UICollectionViewCell & UserEntryValue

protocol UserEntryValue {
    
    /// The Identifier that uniquely identifies this cell in a collection
    var identifier: Identifier { get }
    
    /// The description that accompanies this user entry cell
    var fieldDescription: String { get }
        
}

protocol ShortFormEntryCollectionViewCell: UserEntryCollectionViewCell {
    
    /// Editable UITextField presented to the user.
    var textField: UITextField? { get }
    
}

protocol LongFormEntryCollectionViewCell: UserEntryCollectionViewCell {
    
    /// Editable UITextView presented to the user
    var textView: UITextView? { get }

}

protocol CheckboxCollectionViewCell: UserEntryCollectionViewCell {
    
    /// Checkboxes displayed to the user
    var checkboxes: [Checkbox] { get }
    
}

protocol DiceRollCollectionViewCell: UserEntryCollectionViewCell {
    
    /// Contains the values necessary to perform repeated dice rolls
    var diceRoll: DiceRoll? { get }
    
}
