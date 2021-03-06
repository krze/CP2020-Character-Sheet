//
//  UICollectionViewLayout+Common.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 8/18/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit


extension UICollectionViewLayout {
    
    static func editorDefault() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = EditorCollectionViewConstants.itemSpacing
        layout.minimumInteritemSpacing = EditorCollectionViewConstants.itemSpacing
        
        return layout
    }
    
}
