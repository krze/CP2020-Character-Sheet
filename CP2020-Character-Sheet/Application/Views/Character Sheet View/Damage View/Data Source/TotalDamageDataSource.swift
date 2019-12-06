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
        
        guard let numberOfHitsString = values[DamageField.NumberOfHits.identifier()] as? String,
            let numberOfHits = Int(numberOfHitsString),
            let roll = values[DamageField.Roll.identifier()] as? DiceRoll,
            let locationArray = (values[DamageField.Location.identifier()] as? CheckboxConfig)?.selectedStates,
            let damageTypeString = (values[DamageField.DamageType.identifier()] as? CheckboxConfig)?.selectedStates.first,
            let damageType = DamageType(rawValue: damageTypeString),
            let coverSPString = values[DamageField.CoverSP.identifier()] as? String,
            let coverSP = Int(coverSPString)
        else {
            return
        }

        let locations: [BodyLocation] = {
            // Only allowing 1 selectable location.
            if locationArray.count == 1,
                let locationString = locationArray.first,
                let location = BodyLocation.from(string: locationString) {
                return [location]
            }
            return []
        }()


        let incomingDamageModel = IncomingDamage(roll: roll,
                                                 numberOfHits: numberOfHits,
                                                 damageType: damageType,
                                                 hitLocations: locations,
                                                 coverSP: coverSP)
        model.apply(damage: incomingDamageModel) { result in
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
