//
//  PreselectedTextCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A user entry view of EntryType.SuggestedText or EntryType.EnforcedChoiceText
final class PreselectedTextCollectionViewCell: UserEntryCollectionViewCell {

    var enteredValue: String?
    
    // Dictates whether the suggested entry is enforced or not
    private var enforced = false
    private var suggestedMatches = [String]()
    
    func setup(with identifier: Identifier, placeholder: String, description: String) {
        
    }
    
}
