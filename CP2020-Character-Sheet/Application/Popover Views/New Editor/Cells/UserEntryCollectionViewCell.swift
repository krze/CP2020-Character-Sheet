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
    var enteredValue: String? { get }
    
    func setup(with identifier: Identifier, placeholder: String, description: String)
}
