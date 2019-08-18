//
//  EditorCollectionViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class EditorCollectionViewController: UICollectionViewController, UIPopoverPresentationControllerDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UserEntryDelegate {

    private let enforcedOrder: [Identifier]
    private let entryTypes: [Identifier: EntryType]
    private let placeholderValues: [Identifier: String]
    private let descriptions: [Identifier: String]
    private let paddingRatio: CGFloat
    
    private var valuesChanged = false
    private var currentValues = [Identifier: String]() {
        didSet {
            valuesChanged = true
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
    
        // Configure the cell
    
        return cell
    }
    
    // MARK: UIPresentationControllerDelegate
    
    @objc func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // MARK: UserEntryViewDelegate
    
    func entryDidFinishEditing(identifier: Identifier, value: String?, moveToNextField: Bool) {
        if let value = value {
            currentValues[identifier] = value
        }
        
        if moveToNextField {
            var currentIdentifier = identifier
            var currentIndex = enforcedOrder.firstIndex(of: identifier)
            
            while enforcedOrder.indices.last != currentIndex?.advanced(by: 1) {
                if let entryType = entryTypes[currentIdentifier] {
                    switch entryType {
                    case .Static:
                        
                        makeNextCellFirstResponder(index: currentIndex)
                        break
                    default:
                        guard let nextIndex = currentIndex?.advanced(by: 1) else {
                            break
                        }
                        
                        currentIdentifier = enforcedOrder[nextIndex]
                        currentIndex = nextIndex
                    }
                }
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
        
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: entryType.cellHeight())
    }
    
    private func dismissEditor() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func makeNextCellFirstResponder(index: Int?) {
        if let index = index,
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? UserEntryCollectionViewCell {
            cell.makeFirstResponder()
        }
    }
    
    @objc private func save() {
        dismissEditor()
    }
}
