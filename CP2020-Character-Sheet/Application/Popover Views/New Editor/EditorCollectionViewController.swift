//
//  EditorCollectionViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class EditorCollectionViewController: UICollectionViewController, UIPopoverPresentationControllerDelegate, UICollectionViewDelegateFlowLayout {
    private let enforcedOrder: [Identifier]
    private let entryTypes: [Identifier: EntryType]
    private let placeholderValues: [Identifier: String]
    private let descriptions: [Identifier: String]
    private let paddingRatio: CGFloat
    
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
        default:
            return UICollectionViewCell()
        }
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: UIPresentationControllerDelegate
    
    @objc func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
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
    
    @objc private func save() {
        dismissEditor()
    }
}
