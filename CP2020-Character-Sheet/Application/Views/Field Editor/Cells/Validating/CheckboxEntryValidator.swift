//
//  CheckboxEntryValidator.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/18/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class CheckboxEntryValidator: UserEntryValidating, CheckboxSelectionDelegate {
    // Checkboxes do not have suggested matches
    let suggestedMatches = [String]()
    private(set) var identifier: Identifier
    private(set) var isValid = true
    private var invalidState: InvalidState?
    
    var currentValue: AnyHashable? {
        guard let existingConfig = cell.checkboxConfig else { return nil }
        let selectedCheckboxes = cell.checkboxes.filter({ $0.selected })
        
        // Ensures we're returning [String]? rather than [String?]?
        var selectedIdentifiers = [Identifier]()
        selectedCheckboxes.forEach { checkbox in
            if let identifier = checkbox.label.text {
                selectedIdentifiers.append(identifier)
            }
        }
        
        let config = CheckboxConfig(choices: existingConfig.choices,
                                    maxChoices: existingConfig.maxChoices,
                                    minChoices: existingConfig.minChoices,
                                    selectedStates: selectedIdentifiers)
        
        return config
    }
    
    weak var delegate: UserEntryDelegate?
    
    private let cell: CheckboxEntryCollectionViewCell
    
    init(with cell: CheckboxEntryCollectionViewCell) {
        self.cell = cell
        identifier = cell.identifier
        
        self.cell.checkboxes.forEach { $0.delegate = self }
        
        validate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveWasCalled), name: .saveWasCalled, object: nil)
    }
    
    // MARK: UserEntryValidating
    
    func makeFirstResponder() -> Bool {
        return false
    }
    
    @objc func saveWasCalled() {
        validate()
        
        if !isValid {
            showWarning()
        }
    }
    
    func replaceWithSuggestedMatch(_ value: AnyHashable) {
        guard let suggestedMatches = value as? [String] else { return }
        var matchingCheckboxes = [Checkbox]()
        suggestedMatches.forEach { identifier in
            if let match = cell.checkboxes.first(where: { $0.label.text == identifier }) {
                matchingCheckboxes.append(match)
            }
        }
        
        var nonMatchingCheckboxes = cell.checkboxes
        
        matchingCheckboxes.forEach { checkbox in
            nonMatchingCheckboxes.removeAll(where: { $0 == checkbox })
        }
        
        // Make sure the matching checkboxes are selected
        
        matchingCheckboxes.forEach { $0.selectionPrevented = false }
        matchingCheckboxes.forEach { checkbox in
            if checkbox.selected {
                return
            }
            
            checkbox.flipSelectionState()
        }
        
        // Make sure the non-matching checkboxes are deselected
        
        nonMatchingCheckboxes.forEach { $0.selectionPrevented = false }
        nonMatchingCheckboxes.forEach { checkbox in
            guard checkbox.selected else { return }
            
            checkbox.flipSelectionState()
        }
    }
    
    func forceWarning() {
        showPopup()
    }
    
    // MARK: CheckboxSelectionDelegate
    
    func checkboxSelected(_ checkbox: Checkbox) {
        guard let config = cell.checkboxConfig else { return }
        
        var selectedCheckboxCount: Int {
            cell.checkboxes.filter({ $0.selected }).count
        }
        
        while selectedCheckboxCount > config.maxChoices {
            let allOtherCheckboxes = cell.checkboxes.filter { $0 != checkbox && $0.selected }
            allOtherCheckboxes.first?.flipSelectionState()
        }
        
        validate()
        delegate?.entryDidFinishEditing(identifier: identifier, value: currentValue, shouldGetSuggestion: false, resignLastResponder: {})
    }
    
    func checkboxDeselected(_ checkbox: Checkbox) {
        validate()
        delegate?.entryDidFinishEditing(identifier: identifier, value: currentValue, shouldGetSuggestion: false, resignLastResponder: {})
    }
    
    func checkboxTappedWhileSelectionDisabled(_ checkbox: Checkbox) {
        guard let checkboxName = checkbox.label.text else { return }
        
        showAlert(title: "Selection disabled", message: "You cannot \(checkbox.selected ? "deselect" : "select") \(checkboxName)")
    }
    
    private func validate() {
        guard let config = cell.checkboxConfig else { return }
        let minimumNotMet = config.minChoices > 0 &&
            cell.checkboxes.filter({ $0.selected }).count == 0
        let maxiumumExceeded = cell.checkboxes.filter({ $0.selected }).count > config.maxChoices
        
        invalidState = {
            if minimumNotMet {
                return .minimumNotMet
            }
            else if maxiumumExceeded {
                return .maximumExceeded
            }
            
            return nil
        }()
        
        guard invalidState != nil else {
            isValid = true
            hideWarning()
            return
        }
        
        showWarning()
        isValid = false
    }
    
    private func showWarning() {
        cell.setCheckboxBackgroundColor(StyleConstants.Color.red.withAlphaComponent(0.5))
    }

    private func hideWarning() {
        cell.setCheckboxBackgroundColor(StyleConstants.Color.light)
    }
    
    // MARK: Private
    
    private func showPopup() {
        guard let invalidState = invalidState,
            let config = cell.checkboxConfig else {
                return
        }
        
        var title = ""
        var message = ""
        
        switch invalidState {
        case .minimumNotMet:
            title = "\(cell.identifier) requires more information"
            message = "A minimum of \(config.minChoices) selected choice\(config.minChoices > 1 ? "s" : "") is required. Please select more options."
        case .maximumExceeded:
            title = "\(cell.identifier) exceded maximum options selected"
            message = "Exceeding \(config.maxChoices) selected choice\(config.maxChoices > 1 ? "s" : "") is forbidden. Please select fewer options."
        }
        
        showAlert(title: title, message: message)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertViewStrings.dismissButtonTitle, style: .default, handler: nil))
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }
    
    private enum InvalidState {
        case minimumNotMet, maximumExceeded
    }
}
