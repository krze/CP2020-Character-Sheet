//
//  EditorCollectionViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class EditorCollectionViewController: UICollectionViewController, UIPopoverPresentationControllerDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UserEntryDelegate {
    
    weak var delegate: EditorValueReciever?

    private let enforcedOrder: [Identifier]
    private let entryTypes: [Identifier: EntryType]
    private let placeholderValues: [Identifier: AnyHashable]
    private let descriptions: [Identifier: String]
    private let paddingRatio: CGFloat
    
    private var validators = [UserEntryValidating]()
    
    private weak var saveButton: UIBarButtonItem?
    
    private var valuesChanged = false
    private var currentValues = [Identifier: AnyHashable]()
    
    private var autofillSuggestion: [Identifier: AnyHashable]?
    
    private var saving = false
    
    private let viewModel: EditorCollectionViewModel
    
    init(with viewModel: EditorCollectionViewModel) {
        self.enforcedOrder = viewModel.enforcedOrder
        self.placeholderValues = viewModel.placeholdersWithIdentifiers ?? [Identifier: AnyHashable]()
        self.descriptions = viewModel.descriptionsWithIdentifiers ?? [Identifier: String]()
        self.entryTypes = viewModel.entryTypesForIdentifiers
        self.paddingRatio = viewModel.paddingRatio
        self.viewModel = viewModel
        super.init(collectionViewLayout: viewModel.layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.saveButton = saveButton
        self.saveButton?.isEnabled = false
        self.navigationItem.rightBarButtonItem = saveButton
        // Register cell classes
        collectionView.register(ShortTextEntryCollectionViewCell.self, forCellWithReuseIdentifier: EntryType.Text.cellReuseID())
        collectionView.register(LongTextEntryCollectionViewCell.self, forCellWithReuseIdentifier: EntryType.LongFormText.cellReuseID())
        collectionView.register(CheckboxEntryCollectionViewCell.self, forCellWithReuseIdentifier: CheckboxConfig.editorCellReuseID)
        collectionView.register(DiceRollEntryCollectionViewCell.self, forCellWithReuseIdentifier: EntryType.DiceRoll.cellReuseID())
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return enforcedOrder.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard enforcedOrder.indices.contains(indexPath.row) else {
            return UICollectionViewCell()
        }
        
        let identifier = enforcedOrder[indexPath.row]

        guard let placeholder = placeholderValues[identifier],
            let description = descriptions[identifier],
            let entryType = entryTypes[identifier] else {
                return UICollectionViewCell()
        }
        
        let reuseIdentifier = entryType.cellReuseID()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let value: AnyHashable = {
            if let value = currentValues[identifier] {
                return value
            }
            else {
                return placeholder
            }
        }()
        
        switch entryType {
        case .Text, .Integer, .Static:
            guard let cell = cell as? ShortTextEntryCollectionViewCell,
                let value = value as? String else { return UICollectionViewCell() }
            cell.setup(with: identifier, value: value, description: description)
            var validator = self.validator(for: cell, identifier: identifier, entryType: entryType)
            validator.delegate = self
        case .LongFormText:
            guard let cell = cell as? LongTextEntryCollectionViewCell,
                let value = value as? String else { return UICollectionViewCell() }
            cell.setup(with: identifier, value: value, description: description)
            var validator = self.validator(for: cell, identifier: identifier, entryType: entryType)
            validator.delegate = self
        case .EnforcedChoiceText(let choices), .SuggestedText(let choices):
            guard let cell = cell as? ShortTextEntryCollectionViewCell,
                let value = value as? String else { return UICollectionViewCell() }
            cell.setup(with: identifier, value: value, description: description)
            var validator = self.validator(for: cell, identifier: identifier, entryType: entryType, suggestedMatches: choices)
            validator.delegate = self
        case .Checkbox(_):
            guard let cell = cell as? CheckboxEntryCollectionViewCell,
                let value = value as? CheckboxConfig else { return UICollectionViewCell() }
            cell.setup(with: identifier, checkboxConfig: value, description: description)
            var validator = self.validator(for: cell, identifier: identifier, entryType: entryType)
            validator.delegate = self
            return cell
        case .DiceRoll:
            // FIXME
            return UICollectionViewCell()
        }
        
        currentValues[identifier] = value
        return cell
    }
    
    // MARK: UIPresentationControllerDelegate
    
    @objc func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // MARK: UserEntryDelegate
    
    func userBeganEditing() {
        saveButton?.isEnabled = true
    }
    
    func entryDidFinishEditing(identifier: Identifier, value: AnyHashable?, shouldGetSuggestion: Bool, resignLastResponder: () -> Void) {
        if let value = value {
            if let currentValue = currentValues[identifier],
                currentValue == value {
                return
            }
            
            currentValues[identifier] = value
            valuesChanged = true
        }
        
        guard !saving else { return }
               
        // Only consider moving to the next field if the value supplied is not a checkbox config.
        // This indicates that a keyboard is not present. This is not future proof and is bound to
        // break if the `value` is ever anything other than a String or a CheckboxConfig.
        // This block is a fucking mess and needs reworking.
        var moveToNextField = !(value is CheckboxConfig)

        if shouldGetSuggestion {
            if let value = value,
                let autofillSuggestion = delegate?.autofillSuggestion(for: identifier, value: value),
                self.autofillSuggestion != autofillSuggestion {
                self.autofillSuggestion = autofillSuggestion
                promptForAutoFill(forMatch: value)
                moveToNextField = false
                return
            }
        }
        
        if moveToNextField {
            var currentIdentifier = identifier
            guard var currentIndex = enforcedOrder.firstIndex(of: identifier) else {
                return
            }
            
            while enforcedOrder.indices.contains(currentIndex) {
                if let entryType = entryTypes[currentIdentifier] {
                    switch entryType {
                    case .Static:
                        let nextIndex = currentIndex.advanced(by: 1)
                        currentIdentifier = enforcedOrder[nextIndex]
                        currentIndex = nextIndex
                        continue
                    default:
                        if makeNextCellFirstResponder(currentIndex: currentIndex) {
                            return
                        }
                        else {
                            resignLastResponder()
                            return
                        }
                        
                    }
                }
                resignLastResponder()
                break
            }
        }
        
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard enforcedOrder.indices.contains(indexPath.row) else {
            return CGSize.zero
        }
        
        let identifier = enforcedOrder[indexPath.row]
        guard let entryType = entryTypes[identifier] else {
            return CGSize.zero
        }
        
        let width: CGFloat = {
            let frameWidth = view.safeAreaLayoutGuide.layoutFrame.width
            if let ratio = viewModel.cellWidthRatioForIdentifiers[identifier] {
                return (frameWidth * ratio) - EditorCollectionViewConstants.itemSpacing
            }
            else {
                return frameWidth
            }
        }()
        
        return CGSize(width: width, height: entryType.cellHeight())
    }
    
    private func dismissEditor() {
        self.dismiss(animated: true)
    }
    
    private func makeNextCellFirstResponder(currentIndex: Int?) -> Bool {
        guard let currentIndex = currentIndex else { return false }
        
        if let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex + 1, section: 0)) as? UserEntryCollectionViewCell, let validator = validators.first(where: { $0.identifier == cell.identifier }) {
            return validator.makeFirstResponder()
        }
        
        return false
    }
    
    @objc private func save() {
        defer { saving = false }
        saving = true
        
        NotificationCenter.default.post(name: .saveWasCalled, object: nil)
    
        validators.forEach { validator in
            currentValues[validator.identifier] = validator.currentValue
        }
        
        if let invalidState = validators.first(where: { !$0.isValid }) {
            invalidState.forceWarning()
            return
        }
                
        // TODO: Fix how we track valuesChanged, it's a bit sloppy. Make a differ instead.
        if valuesChanged {
            self.delegate?.valuesFromEditorDidChange(currentValues, validationCompletion: dismissOrWarn)
        }
        else {
            dismissEditor()
        }
    }
    
    /// Dismisses the editor if the change is validated, otherwise shows an alert warning.
    ///
    /// - Parameter result: The result of the validation of the change to the sheet.
    private func dismissOrWarn(_ result: ValidatedEditorResult) {
        switch result {
        case .success:
            dismissEditor()
            return
        case .failure(let violation):
            let title = violation.title()
            let helpText = violation.helpText()
            
            let alert = UIAlertController(title: title, message: helpText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AlertViewStrings.dismissButtonTitle, style: .default, handler: nil))
            NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
            return
        }
    }
    
    private func validator(for cell: UserEntryCollectionViewCell, identifier: Identifier, entryType: EntryType, suggestedMatches: [String] = [String]()) -> UserEntryValidating {
        if let validator = validators.first(where: { $0.identifier == identifier }) {
            return validator
        }
        
        let validator: UserEntryValidating
        
        if let cell = cell as? ShortTextEntryCollectionViewCell {
           validator = ShortFormEntryValidator(with: cell, type: entryType, suggestedMatches: suggestedMatches)
        }
        else if let cell = cell as? LongFormEntryCollectionViewCell {
            validator = LongFormEntryValidator(with: cell, type: entryType, suggestedMatches: suggestedMatches)
        }
        else if let cell = cell as? CheckboxEntryCollectionViewCell {
            validator = CheckboxEntryValidator(with: cell)
        }
        else {
            fatalError("You added a new UserEntryCollectionViewCell but didnt add it here")
        }
        
        validators.append(validator)
        return validator
    }
    
    private func promptForAutoFill(forMatch match: AnyHashable) {
        let match = match as? String ?? "the entry you just provided"
        let alert = UIAlertController(title: "Match for \(match)", message: "Would you like to auto-fill the remaining fields?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: AlertViewStrings.confirmButtonTitle, style: .default, handler: acceptAutoFill(_:)))
        alert.addAction(UIAlertAction(title: AlertViewStrings.rejectButtonTitle, style: .cancel, handler: rejectAutoFill(_:)))
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }
    
    private func acceptAutoFill(_ action: UIAlertAction) {
        guard let autofillSuggestion = autofillSuggestion else { return }
        currentValues = autofillSuggestion
        updateEditorFieldsWithCurrentValues()
    }
    
    private func rejectAutoFill(_ action: UIAlertAction) {
        autofillSuggestion = nil
    }
    
    private func updateEditorFieldsWithCurrentValues() {
        for (identifier, value) in currentValues {
            validators.first(where: { $0.identifier == identifier})?.replaceWithSuggestedMatch(value)
        }
    }
    
}
