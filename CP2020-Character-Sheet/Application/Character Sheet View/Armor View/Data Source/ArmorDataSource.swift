//
//  ArmorDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by iKreb Retina on 11/10/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

final class ArmorDataSource: EditorValueReciever {
    
    private let model: ArmorModel
    
    init(model: ArmorModel) {
        self.model = model
    }

    func valuesFromEditorDidChange(_ values: [Identifier: AnyHashable], validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {}

    func refreshData() {}

    func autofillSuggestion(for identifier: Identifier, value: AnyHashable) -> [Identifier : AnyHashable]? { return nil }

}
