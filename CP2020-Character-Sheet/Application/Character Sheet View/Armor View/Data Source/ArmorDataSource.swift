//
//  ArmorDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by iKreb Retina on 11/10/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class ArmorDataSource: NSObject, EditorValueReciever {
    
    /// If an AnatomyDisplayController is present, this view will be updated as well
    weak var anatomyDisplayController: AnatomyDisplayController? {
        didSet {
            refreshData()
        }
    }
    
    /// Responds to updates to armor changes in the model
    weak var delegate: ArmorDataSourceDelegate?
    
    fileprivate let model: ArmorModel
    
    init(model: ArmorModel) {
        self.model = model

        super.init()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshData),
                                               name: .armorDidChange,
                                               object: nil)
    }

    func valuesFromEditorDidChange(_ values: [Identifier: AnyHashable], validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {}

    @objc func refreshData() {
        var locationsSPS = [BodyLocation: Int]()
        
        BodyLocation.allCases.forEach { location in
            let sps = model.equippedArmor.sps(for: location)
            locationsSPS[location] = sps
            
            // MARK: Update AnatomyDisplayController
            
            anatomyDisplayController?.updateSPSAccessoryView(for: location, newValue: "\(sps)")
            anatomyDisplayController?.updateSPSAccessoryView(for: location, newValue: model.equippedArmor.status(for: location))
        }
        
        // MARK: Update ArmorViewCell
        
        delegate?.armorDidChange(locationSPS: locationsSPS)
    }

    func autofillSuggestion(for identifier: Identifier, value: AnyHashable) -> [Identifier : AnyHashable]? { return nil }

}

extension ArmorDataSource: TableViewManaging {
    
    func createAddArmorButton(_ navigationItem: UINavigationItem) {
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewArmorEditor)), animated: true)
    }
    
    func registerCells(for tableView: UITableView) {
        tableView.register(ColumnTableViewCell.self,
                           forCellReuseIdentifier: ColumnTableConstants.identifier)
        tableView.rowHeight = ColumnTableConstants.rowHeight
        tableView.backgroundColor = StyleConstants.Color.light
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.equippedArmor.armor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColumnTableConstants.identifier, for: indexPath)
        
        if let cell = cell as? ColumnTableViewCell,
            model.equippedArmor.armor.indices.contains(indexPath.row) {
            
            let armor = model.equippedArmor.armor[indexPath.row]
            let columnListing = ColumnListing(name: armor.name,
                                              firstColumnValue: "\(armor.sps)",
                                             secondColumnValue: "\(armor.damageSustained)",
                                              thirdColumnValue: armor.type.rawValue)

            cell.prepare(with: columnListing, viewModel: ColumnTableViewCellModel())
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: ColumnTableConstants.rowHeight)
        let labelText = ArmorStrings.armorName

        let model = ColumnTableViewModel(name: labelText,
                                         firstColumn: ArmorStrings.SPS,
                                         secondColumn: ArmorStrings.damageAbbreviation,
                                         thirdColumn: ArmorStrings.type)
        return ColumnTableViewHeader(viewModel: model, frame: frame)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ColumnTableConstants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ColumnTableConstants.rowHeight
    }
    
    @objc private func showNewArmorEditor() {
        let editorViewController = EditorCollectionViewController(with: EditorCollectionViewModel.newArmor())
        NotificationCenter.default.post(name: .showEditor, object: editorViewController)
    }
    
}
