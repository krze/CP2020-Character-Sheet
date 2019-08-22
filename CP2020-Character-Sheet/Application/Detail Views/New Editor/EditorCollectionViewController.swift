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
    private let placeholderValues: [Identifier: String]
    private let descriptions: [Identifier: String]
    private var fieldValidity = [Identifier: Bool]()
    private let paddingRatio: CGFloat
    
    private weak var saveButton: UIBarButtonItem?
    
    private var valuesChanged = false
    private var currentValues = [Identifier: String]() {
        didSet {
            valuesChanged = true
            saveButton?.isEnabled = true
        }
    }
    
    init(with viewModel: EditorCollectionViewModel) {
        self.enforcedOrder = viewModel.enforcedOrder
        self.placeholderValues = viewModel.placeholdersWithIdentifiers ?? [Identifier: String]()
        self.descriptions = viewModel.descriptionsWithIdentifiers ?? [Identifier: String]()
        self.entryTypes = viewModel.entryTypesForIdentifiers
        self.paddingRatio = viewModel.paddingRatio
        super.init(collectionViewLayout: viewModel.layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        saveButton.isEnabled = false
        self.saveButton = saveButton
        self.navigationItem.rightBarButtonItem = saveButton
        // Register cell classes
        collectionView.register(TextEntryCollectionViewCell.self, forCellWithReuseIdentifier: EntryType.Text.cellReuseID())
        collectionView.register(IntegerEntryCollectionViewCell.self, forCellWithReuseIdentifier: EntryType.Integer.cellReuseID())
        collectionView.register(LongFormTextEntryCollectionViewCell.self, forCellWithReuseIdentifier: EntryType.LongFormText.cellReuseID())
        collectionView.register(EnforcedTextCollectionViewCell.self, forCellWithReuseIdentifier: EntryType.EnforcedChoiceText([]).cellReuseID())
        collectionView.register(SuggestedTextCollectionViewCell.self, forCellWithReuseIdentifier: EntryType.SuggestedText([]).cellReuseID())
        collectionView.register(StaticEntryCollectionViewCell.self, forCellWithReuseIdentifier: EntryType.Static.cellReuseID())
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
        currentValues[identifier] = placeholder
        
        switch entryType {
        case .Text:
            guard let cell = cell as? TextEntryCollectionViewCell else { return UICollectionViewCell() }
            cell.setup(with: identifier, placeholder: placeholder, description: description)
            cell.delegate = self
        case .Integer:
            guard let cell = cell as? IntegerEntryCollectionViewCell else { return UICollectionViewCell() }
            cell.setup(with: identifier, placeholder: placeholder, description: description)
            cell.delegate = self
        case .LongFormText:
            guard let cell = cell as? LongFormTextEntryCollectionViewCell else { return UICollectionViewCell() }
            cell.setup(with: identifier, placeholder: placeholder, description: description)
            cell.delegate = self
        case .EnforcedChoiceText(let requiredChoices):
            guard let cell = cell as? EnforcedTextCollectionViewCell else { return UICollectionViewCell() }
            cell.suggestedMatches = requiredChoices
            cell.setup(with: identifier, placeholder: placeholder, description: description)
            cell.delegate = self
        case .SuggestedText(let suggestedMatches):
            guard let cell = cell as? SuggestedTextCollectionViewCell else { return UICollectionViewCell() }
            cell.suggestedMatches = suggestedMatches
            cell.setup(with: identifier, placeholder: placeholder, description: description)
            cell.delegate = self
        case .Static:
            guard let cell = cell as? StaticEntryCollectionViewCell else { return UICollectionViewCell() }
            cell.setup(with: identifier, placeholder: placeholder, description: description)
            cell.delegate = self
        }
        
        fieldValidity[identifier] = (cell as? UserEntryCollectionViewCell)?.entryIsValid
        
        // Configure the cell
    
        return cell
    }
    
    // MARK: UIPresentationControllerDelegate
    
    @objc func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // MARK: UserEntryViewDelegate
    
    func entryDidFinishEditing(identifier: Identifier, value: String?) {
        if let value = value {
            currentValues[identifier] = value
        }
        
        let moveToNextField = !currentValues.filter( { $0.value == "" }).isEmpty
        
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
                        makeNextCellFirstResponder(currentIndex: currentIndex)
                    }
                }
                
                break
            }
        }
    }
    
    func fieldValidityChanged(identifier: String, newValue: Bool) {
        fieldValidity[identifier] = newValue
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
        
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: entryType.cellHeight())
    }
    
    private func dismissEditor() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func makeNextCellFirstResponder(currentIndex: Int?) {
        guard let currentIndex = currentIndex else { return }
        
        if let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex + 1, section: 0)) as? UserEntryCollectionViewCell {
            cell.makeFirstResponder()
        }
    }
    
    @objc private func save() {
        let allValid = !fieldValidity.contains(where: { $1 == false })
        // NEXT: There's difficulty validating all data as valid as a whole.
        // 1. Determine the minimum validity for each type of field (i.e. is a number, is one of the required choices, etc)
        // 2. Pass fields to a validator based on the datasource to determine if it's valid as a whole. Or inject a validator.

        NotificationCenter.default.post(name: .saveWasCalled, object: nil)
        if allValid && valuesChanged {
            self.delegate?.valuesFromEditorDidChange(currentValues)
            dismissEditor()
        }
        else {
            let identifiers: [String] = fieldValidity.filter({ $1 == false })
                .compactMap({ key, value in
                    return key
                })
            
            let fields = identifiers.joined(separator: ", ")
            let alert = UIAlertController(title: "Some fields need your attention", message: "The following field\(identifiers.count > 1 ? "s" : "") ha\(identifiers.count > 1 ? "ve" : "s an") invalid value\(identifiers.count > 1 ? "s" : ""):\n\(fields)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: SkillStrings.dismissHelpPopoverButtonText, style: .default, handler: nil))
            NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
        }
        
    }
}
