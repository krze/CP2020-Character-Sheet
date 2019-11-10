//
//  ArmorDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by iKreb Retina on 11/10/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

final class ArmorDataSource: EditorValueReciever {

    func valuesFromEditorDidChange(_ values: [Identifier : String], validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {}

    func refreshData() {}

    func autofillSuggestion(for identifier: Identifier, value: String) -> [Identifier : String]? { return nil }

}
