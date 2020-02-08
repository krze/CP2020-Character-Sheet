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
    let entryTypesForIdentifiers: [Identifier: EntryType]
    
    let placeholdersWithIdentifiers: [Identifier: AnyHashable]?
    let descriptionsWithIdentifiers: [Identifier: String]?
    
    let enforcedOrder: [Identifier]
    
    var numberOfRows: Int {
        return enforcedOrder.count
    }
    
    let paddingRatio = StyleConstants.Size.textPaddingRatio
    
    let mode: EditorMode
    
    var cellWidthRatioForIdentifiers = [Identifier: CGFloat]()
}

struct EditorCollectionViewConstants {
    
    static let headerRowHeight: CGFloat = 32
    static let editableSingleLineRowHeight: CGFloat = 44
    static let editableMultiLineRowHeightMaximum: CGFloat = 132
    static let itemSpacing: CGFloat = 3
    
}

