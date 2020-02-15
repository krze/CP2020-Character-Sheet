//
//  ArmorDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by iKreb Retina on 11/10/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class ArmorDataSource: NSObject, EditorValueReciever, ViewCreating {
    
    weak var viewCoordinator: ViewCoordinating?
    
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

    func valuesFromEditorDidChange(_ values: [Identifier: AnyHashable], validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        guard
            let name = values[ArmorField.Name.identifier()] as? String,
            let spString = values[ArmorField.SP.identifier()] as? String,
            let sp = Int(spString),
            let armorTypeArray = (values[ArmorField.ArmorType.identifier()] as? CheckboxConfig)?.selectedStates,
            let evString = values[ArmorField.EV.identifier()] as? String,
            let ev = Int(evString),
            let locationsArray = (values[ArmorField.Locations.identifier()] as? CheckboxConfig)?.selectedStates,
            let zoneArray = (values[ArmorField.Zone.identifier()] as? CheckboxConfig)?.selectedStates
            else {
                return
        }

        let locations = locationsArray.map({ BodyLocation.from(string: $0) }).compactMap { $0 }
       
        guard
            let armorTypeString = armorTypeArray.first,
            let armorType = ArmorType(rawValue: armorTypeString),
            let zone = zoneArray.map({ ArmorZone.zone(from: $0) }).first
            else {
                return
        }
        
        let armor = Armor(name: name, type: armorType, sp: sp, ev: ev, zone: zone, locations: locations)
        
        model.equippedArmor.equip(armor, validationCompletion: completion)
    }

    @objc func refreshData() {
        var locationsSP = [BodyLocation: Int]()
        
        BodyLocation.allCases.forEach { location in
            let sp = model.equippedArmor.sp(for: location)
            locationsSP[location] = sp
            
            // MARK: Update AnatomyDisplayController
            
            anatomyDisplayController?.updateSPAccessoryView(for: location, newValue: "\(sp)")
            anatomyDisplayController?.updateSPAccessoryView(for: location, newValue: model.equippedArmor.status(for: location))
        }
        
        // MARK: Update ArmorViewCell
        
        delegate?.armorDidChange(locationSP: locationsSP)
        anatomyDisplayController?.tableView?.reloadData()
    }

    func autofillSuggestion(for identifier: Identifier, value: AnyHashable) -> [Identifier : AnyHashable]? { return nil }

}

// MARK: TableViewManaging

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
    
    // MARK: UITableViewDataSource
    
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
                                  firstColumnValue: "\(armor.sp)",
                                 secondColumnValue: "\(armor.status().abbreviation())",
                                  thirdColumnValue: armor.type.rawValue)

            cell.prepare(with: columnListing, viewModel: ColumnTableViewCellModel())
        }

        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: ColumnTableConstants.headerHeight)
        let labelText = ArmorStrings.armorName

        let model = ColumnTableViewModel(name: labelText,
                                         firstColumn: ArmorStrings.SP,
                                         secondColumn: ArmorStrings.damageAbbreviation,
                                         thirdColumn: ArmorStrings.type)
        return ColumnTableViewHeader(viewModel: model, frame: frame)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ColumnTableConstants.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ColumnTableConstants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let armor = model.equippedArmor.armor[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.model.equippedArmor.remove(armor) { (result) in
                switch result {
                case .success:
                    completion(true)
                default:
                    completion(false)
                }
            }
        }
        
        action.backgroundColor = StyleConstants.Color.red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // MARK: Private
    
    @objc private func showNewArmorEditor() {
        let editorViewController = EditorCollectionViewController(with: EditorCollectionViewModel.newArmor())
        editorViewController.delegate = self
        viewCoordinator?.viewControllerNeedsPresentation(vc: editorViewController)
    }
    
}
