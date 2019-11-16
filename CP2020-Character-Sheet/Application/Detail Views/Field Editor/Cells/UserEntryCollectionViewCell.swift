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
    
    var identifier: Identifier { get }
    var fieldDescription: String { get }
    
    func setup(with identifier: Identifier, value: String, description: String)
    
}

protocol ShortFormEntryCollectionViewCell: UserEntryCollectionViewCell {
    
    var textField: UITextField? { get }
    
}

protocol LongFormEntryCollectionViewCell: UserEntryCollectionViewCell {
    
    var textView: UITextView? { get }

}
