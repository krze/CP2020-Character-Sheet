//
//  EditorCollectionViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

struct EditorCollectionViewModel: MarginCreator {
    let layout: UICollectionViewLayout
    let entryTypesForIdentifiers: [Identifier : EntryType]
    
    let placeholdersWithIdentifiers: [Identifier : String]?
    let descriptionsWithIdentifiers: [Identifier : String]?
    
    let enforcedOrder: [Identifier]
    
    var numberOfRows: Int {
        return enforcedOrder.count
    }
    
    let paddingRatio = StyleConstants.SizeConstants.textPaddingRatio

}

struct EditorCollectionViewConstants {
    
    static let headerRowHeight: CGFloat = 32
    static let editableSingleLineRowHeight: CGFloat = 44
    static let editableMultiLineRowHeightMaximum: CGFloat = 132
    
}

