//
//  TotalDamageDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class TotalDamageDataSource: NSObject, EditorValueReciever {

    private let model: DamageModel
    private let maxDamage: Int
    var currentDamage: Int {
        return model.damage
    }
    weak var delegate: TotalDamageDataSourceDelegate?
    
    /// If an AnatomyDisplayController is present, this view will be updated as well
    weak var anatomyDisplayController: AnatomyDisplayController? {
        didSet {
            refreshData()
        }
    }
    
    init(model: DamageModel) {
        self.model = model
        self.maxDamage = Rules.Damage.maxDamagePoints
        super.init()
        
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
        model.apply(damage: incomingDamageModel, validationCompletion: completion)
    }
    
    @objc func refreshData() {
        let wounds = model.wounds

        BodyLocation.allCases.forEach { location in
            let damage = wounds.filter({ !$0.isMultiLocation() && $0.locations.contains(location) }).reduce(0, { $0 + $1.totalDamage()})
            let hasMortalDamage = wounds.contains(where: { !$0.isMultiLocation() && $0.isMortal() })
            let status: BodyPartStatus = hasMortalDamage ? .Destroyed : damage > 0 ? .Damaged : .Undamaged
            
            // MARK: Update AnatomyDisplayController
            
            anatomyDisplayController?.updateSPAccessoryView(for: location, newValue: "\(damage)")
            anatomyDisplayController?.updateSPAccessoryView(for: location, newValue: status)
        }
        
        delegate?.updateCells(to: currentDamage)
        anatomyDisplayController?.tableView?.reloadData()
    }
    
    func autofillSuggestion(for identifier: Identifier, value: AnyHashable) -> [Identifier : AnyHashable]? {
        return nil
    }
    
}

// MARK: TableViewManaging

extension TotalDamageDataSource: TableViewManaging {
    
    func createDamageButtons(_ navigationItem: UINavigationItem) {
        // NEXT: figre out how to pop options for healing damage
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewDamageEditor)), animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.wounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColumnTableConstants.identifier, for: indexPath)
        
        if let cell = cell as? ColumnTableViewCell,
            model.wounds.indices.contains(indexPath.row) {
            
            let wound = model.wounds[indexPath.row]
            let location: String = {
                guard wound.locations.count == 1,
                    let location = wound.locations.first else {
                        return BodyStrings.multipleLocations
                }
                
                return location.descriptiveText()
            }()
            let columnListing = ColumnListing(name: location,
                                              firstColumnValue: "\(wound.totalDamage())",
                                              secondColumnValue: "\(wound.traumaType.abbreviation())",
                                              thirdColumnValue: "\(wound.isFatal() ? "YES" : "NO")")

            cell.prepare(with: columnListing, viewModel: ColumnTableViewCellModel())
        }

        
        return cell
    }
    
    func registerCells(for tableView: UITableView) {
        tableView.register(ColumnTableViewCell.self,
                           forCellReuseIdentifier: ColumnTableConstants.identifier)
        tableView.rowHeight = ColumnTableConstants.rowHeight
        tableView.backgroundColor = StyleConstants.Color.light
    }
    
    // MARK: UITableViewDelegate
      
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: ColumnTableConstants.headerHeight)
        let labelText = BodyStrings.locationOfDamage
        
        let model = ColumnTableViewModel(name: labelText,
                                         firstColumn: DamageStrings.damageAbbreviation,
                                         secondColumn: DamageStrings.traumaAbbreviation,
                                         thirdColumn: DamageStrings.fatal)
        return ColumnTableViewHeader(viewModel: model, frame: frame)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ColumnTableConstants.headerHeight
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ColumnTableConstants.rowHeight
    }
  
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard model.wounds.indices.contains(indexPath.row) else { return nil }
        
        let wound = model.wounds[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Heal") { (action, view, completion) in
            self.model.remove(wound) { (result) in
                switch result {
                case .success: completion(true)
                default: completion(false)
                }
            }
        }
      
        action.backgroundColor = StyleConstants.Color.red
        return UISwipeActionsConfiguration(actions: [action])
    }
  
    
    // MARK: Private
    
    @objc private func showNewDamageEditor() {
        let editorViewController = EditorCollectionViewController(with: EditorCollectionViewModel.incomingDamage())
        editorViewController.delegate = self
        NotificationCenter.default.post(name: .showEditor, object: editorViewController)
    }
    
}
