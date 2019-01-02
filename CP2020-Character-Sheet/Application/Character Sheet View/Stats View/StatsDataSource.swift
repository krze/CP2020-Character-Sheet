//
//  StatsDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/1/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class StatsDataSource: NSObject, EditorValueReciever, NotifiesEditorNeeded {

    private let statsModel: StatsModel
    
    init(statsModel: StatsModel) {
        self.statsModel = statsModel
    }
    
    func valuesFromEditorDidChange(_ values: [Identifier : String]) {
        
    }
    
    func editorRequested(currentFieldStates: [CurrentFieldState], enforcedOrder: [String], sourceView: UIView) {
        let parameters = currentFieldStates.popoverViewModelParameters()
        let popoverViewModel = PopoverEditorViewModel(numberOfColumns: 2,
                                                      numberOfRows: parameters.entryTypes.rowsNecessaryForColumn(count: 2),
                                                      rowsWithIdentifiers: parameters.rowsWithIdentifiers,
                                                      placeholdersWithIdentifiers: parameters.placeholdersWithIdentifiers,
                                                      enforcedOrder: enforcedOrder,
                                                      labelWidthRatio: 0.5)
        let editorConstructor = EditorConstructor(dataSource: self,
                                                  viewModel: popoverViewModel,
                                                  popoverSourceView: sourceView)
        
        NotificationCenter.default.post(name: .showEditor, object: editorConstructor)
    }
    
}
