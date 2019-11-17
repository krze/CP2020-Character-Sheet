//
//  ColumnListing.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

struct ColumnListing {
    
    let name: String
    let firstColumnValue: String
    let secondColumnValue: String
    let thirdColumnValue: String
    
}

protocol ColumnListingProviding {
    
    /// Provides a ColumnListing representing itself for a ColumnTableViewCell
    func columnListing() -> ColumnListing
}
