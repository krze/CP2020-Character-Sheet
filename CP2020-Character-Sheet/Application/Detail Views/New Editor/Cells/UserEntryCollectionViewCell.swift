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
    var delegate: UserEntryDelegate? { get set }
    var identifier: Identifier { get }
    var enteredValue: String? { get }
    var entryIsValid: Bool { get }
    
    func setup(with identifier: Identifier, placeholder: String, description: String)
    
    func makeFirstResponder()
    
    func saveWasCalled()
    
}
