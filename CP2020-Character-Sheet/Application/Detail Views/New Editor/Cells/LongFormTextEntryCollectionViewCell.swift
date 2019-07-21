//
//  LongFormTextEntryCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class LongFormTextEntryCollectionViewCell: UserEntryCollectionViewCell {

    private(set) var identifier = ""
    
    weak var delegate: UserEntryDelegate?
    
    var enteredValue: String?
    let entryIsValid: Bool = true
    
    func setup(with identifier: Identifier, placeholder: String, description: String) {
        
    }
    
    func makeFirstResponder() {
        
    }
    
}
