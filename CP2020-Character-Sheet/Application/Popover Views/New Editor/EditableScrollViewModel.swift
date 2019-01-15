//
//  EditableScrollViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/15/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

struct EditableScrollViewModel: MarginCreator {
    
    let paddingRatio: CGFloat = StyleConstants.SizeConstants.textPaddingRatio
    
    let lightColor = StyleConstants.Color.light
    let darkColor = StyleConstants.Color.dark
    let blueColor = StyleConstants.Color.blue
    let redColor = StyleConstants.Color.red
    
    func userEntryViewModel(for entryType: EntryType, header: String, description: String = "", placeholder: String = "") -> UserEntryViewModel {
        return UserEntryViewModel(type: entryType, headerText: header, descriptionText: description, placeholderText: placeholder)
    }
}

struct EditableScrollViewModelConstants {
    
    static let headerRowHeight: CGFloat = 32
    static let descriptionRowHeight: CGFloat = 32
    static let editableSingleLineRowHeight: CGFloat = 44
    static let editableMultiLineRowHeightMaximum: CGFloat = 132
    
}
