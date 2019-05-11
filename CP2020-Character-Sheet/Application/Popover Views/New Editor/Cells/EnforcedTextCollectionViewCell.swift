//
//  EnforcedTextCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 5/11/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A user entry view of EntryType.SuggestedText or EntryType.EnforcedChoiceText
final class EnforcedTextCollectionViewCell: UserEntryCollectionViewCell {
    
    var enteredValue: String?
    
    private var requiredMatches = [String]()
    
    func setup(with identifier: Identifier, placeholder: String, description: String) {
        
    }
    
}
