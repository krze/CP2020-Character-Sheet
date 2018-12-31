//
//  EditorConstructor.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/31/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Data structure used to pass info along a notification to construct the requested view controller
struct EditorConstructor {
    
    private let viewModel: PopoverEditorViewModel
    private let dataSource: EditorValueReciever
    
    init(dataSource: EditorValueReciever, viewModel: PopoverEditorViewModel) {
        self.viewModel = viewModel
        self.dataSource = dataSource
    }
    
    func createEditor(with window: CGRect) -> EditorViewController {
        return EditorViewController(with: dataSource, windowFrame: window, viewModel: viewModel)
    }
}
