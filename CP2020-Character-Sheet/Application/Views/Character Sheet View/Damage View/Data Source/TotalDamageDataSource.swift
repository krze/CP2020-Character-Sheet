//
//  TotalDamageDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class TotalDamageDataSource: EditorValueReciever {

    private let model: DamageModel
    private let maxDamage: Int
    var currentDamage: Int {
        return model.damage
    }
    weak var delegate: TotalDamageDataSourceDelegate?
    
    init(model: DamageModel) {
        self.model = model
        self.maxDamage = Rules.Damage.maxDamagePoints
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .damageDidChange, object: nil)
    }
    
    func valuesFromEditorDidChange(_ values: [Identifier : AnyHashable], validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        guard let incomingDamageString = values[DamageStrings.damage] as? String, let incomingDamage = Int(incomingDamageString) else {
            return
        }
        
        model.apply(damage: incomingDamage) { result in
            switch result {
            case .failure(let violation):
                let alert = UIAlertController(title: violation.title(), message: violation.helpText(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: AlertViewStrings.dismissButtonTitle, style: .default, handler: nil))
                NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
            case .success(_):
                return
            }
        }
    }
    
    @objc func refreshData() {
        delegate?.updateCells(to: currentDamage)
    }
    
    func autofillSuggestion(for identifier: Identifier, value: AnyHashable) -> [Identifier : AnyHashable]? {
        return nil
    }
    
}
