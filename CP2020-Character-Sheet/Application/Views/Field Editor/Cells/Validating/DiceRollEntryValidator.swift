//
//  DiceRollEntryValidator.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/2/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class DiceRollEntryValidator: NSObject, UserEntryValidating, UITextFieldDelegate {
    let suggestedMatches = [String]()
    
    private(set) var identifier = ""
    private(set) var isValid = true
    
    private(set) var currentValue: AnyHashable? = nil
    
    var delegate: UserEntryDelegate?
    
    private let cell: DiceRollEntryCollectionViewCell
    private let maximumLength = 2
    
    private var invalidFields = [Field]()
    
    init(with cell: DiceRollEntryCollectionViewCell) {
        self.cell = cell
        
        super.init()
        
        self.cell.numberTextField?.delegate = self
        self.cell.sidesTextField?.delegate = self
        self.cell.modifierTextField?.delegate = self
        
        validateAllFields()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveWasCalled), name: .saveWasCalled, object: nil)
    }
    
    func makeFirstResponder() -> Bool {
        cell.numberTextField?.becomeFirstResponder()
        return true
    }
    
    @objc func saveWasCalled() {
        validateAllFields()
        
        if !isValid {
            showPopup()
        }
    }
    
    func replaceWithSuggestedMatch(_ value: AnyHashable) {}
    
    func forceWarning() {
        showPopup()
    }
    
    // MARK - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validate(textField)

        if textField == cell.numberTextField {
            cell.sidesTextField?.becomeFirstResponder()
        }
        else if textField == cell.sidesTextField {
            cell.modifierTextField?.becomeFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == cell.modifierTextField {
            modifierAdded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validate(textField)
        
        if textField == cell.modifierTextField && textField.text?.count == 0 {
            modifierRemoved()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentLength = textField.text?.count ?? 0
        let replacementLength = string.count
        let rangeLength = range.length
        
        let newLength = currentLength - rangeLength + replacementLength
        let returnHit = string.contains("\n")
        
        
        return newLength <= maximumLength || returnHit
    }
    
    // MARK: Private
    
    private func validate(_ textField: UITextField) {
        guard let field = field(for: textField) else { return }
        let enteredValue = textField.text ?? ""
        
        if enteredValue.count == 0 && field == .modifier {
            modifierRemoved()
            return
        }
        
        if let intValue = Int(enteredValue), intValue >= 1, intValue <= 99 {
            textField.text = String(intValue)
            invalidFields.removeAll(where: { $0 == field })
            isValid = invalidFields.count == 0
            hideWarning(on: textField)
        }
        else {
            invalidFields.append(field)
            isValid = false
            showWarning(on: textField)
        }
        
    }
    
    private func validateAllFields() {
        if let numberTextField = self.cell.numberTextField,
            let sidesTextField = self.cell.sidesTextField,
            let modifierTextField = self.cell.modifierTextField {
            validate(numberTextField)
            validate(sidesTextField)
            validate(modifierTextField)
        }
    }
    
    private func field(for textField: UITextField) -> Field? {
        if textField == cell.numberTextField {
            return .numberOfDice
        }
        else if textField == cell.sidesTextField {
            return .numberOfSides
        }
        else if textField == cell.modifierTextField {
            return .modifier
        }
        
        return nil
    }
    
    private func showWarning(on textField: UITextField) {
        textField.backgroundColor = StyleConstants.Color.red.withAlphaComponent(0.5)
    }
    
    private func hideWarning(on textField: UITextField) {
        textField.backgroundColor = StyleConstants.Color.light
    }
    
    private func modifierAdded() {
        cell.plusSignLabel?.textColor = StyleConstants.Color.dark
    }
    
    private func modifierRemoved() {
        cell.plusSignLabel?.textColor = StyleConstants.Color.gray
    }
    
    private func showPopup() {
        guard !invalidFields.isEmpty else { return }
        
        let count = invalidFields.count
        let title = "Dice Roll not valid."
        var message = "The following field\(count > 1 ? "s" : "") \(count > 1 ? "are" : "is") invalid:"
        
        invalidFields.enumerated().forEach { index, field in
            message = message + "\n\(field.description())"
        }
        
        showAlert(title: title, message: message)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertViewStrings.dismissButtonTitle, style: .default, handler: nil))
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }
    
    private enum Field {
        case numberOfDice, numberOfSides, modifier
        
        func description() -> String {
            switch self {
            case .numberOfDice:
                return "The number of dice."
            case .numberOfSides:
                return "The number of sides."
            case .modifier:
                return "The roll modifier."
            }
        }
    }
}

