//
//  StackedEntryView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/15/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

protocol StackedEntryViewModel {
    
    /// The total height necessary to contain every row (including headers, description, and user input for each row)
    var minimumHeightForAllRows: CGFloat { get }
    
    /// A dictionary of Identifiers associated with the entry types
    var entryTypesForIdentifiers: [Identifier: EntryType] { get }
    
    /// A dictionary of Identifiers associated with the placeholder text for that field.
    var placeholdersWithIdentifiers: [Identifier: String]? { get }
    
    /// The enforced order of the rows, using identifiers.
    var enforcedOrder: [Identifier] { get }
    
    /// The width of the label (aka header) that indicates to the user what the entry field is for
    var labelWidthRatio: CGFloat { get }
    
    /// The number of columns to add entry views to
    var numberOfColumns: Int { get }
    
    /// The number of rows in the user entry view collection.
    var numberOfRows: Int { get }
    
    /// Whether or not to include space at the bottom of the view for buttons
    var includeSpaceForButtons: Bool { get }
}
