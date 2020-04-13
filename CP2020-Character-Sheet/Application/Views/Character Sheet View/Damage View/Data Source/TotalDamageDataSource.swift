//
//  TotalDamageDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class TotalDamageDataSource: NSObject, EditorValueReciever, ViewCreating {
    
    weak var viewCoordinator: ViewCoordinating?

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
    
    private var damageReducerHelper: DamageReducerHelper?
    
    init(model: DamageModel) {
        self.model = model
        self.maxDamage = Rules.Damage.maxDamagePoints
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .damageDidChange, object: nil)
    }
    
    func valuesFromEditorDidChange(_ values: [Identifier : AnyHashable], validationCompletion completion: @escaping ValidatedCompletion) {
        
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
            let locationWounds = wounds.filter({ $0.location == location })
            let damage = locationWounds.reduce(0, { $0 + $1.damageAmount})
            let hasMortalDamage = locationWounds.contains(where: { $0.isMortal() })
            let status: BodyPartStatus = hasMortalDamage ? .Destroyed : damage > 0 ? .Damaged : .Undamaged
            
            // MARK: Update AnatomyDisplayController
            
            anatomyDisplayController?.updateSPAccessoryView(for: location, newValue: "\(damage)")
            anatomyDisplayController?.updateSPAccessoryView(for: location, newValue: status)
        }
        
        delegate?.updateCells(to: currentDamage)
        anatomyDisplayController?.tableView?.reloadData()
        
//        if !model.saveRolls.isEmpty {
//            showSavePopup(with: model.saveRolls)
//        }
    }
    
    func autofillSuggestion(for identifier: Identifier, value: AnyHashable) -> [Identifier : AnyHashable]? {
        return nil
    }
    
}

// MARK: TableViewManaging

extension TotalDamageDataSource: TableViewManaging {
    
    func createDamageButtons(_ navigationItem: UINavigationItem) {
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewDamageEditor)), animated: true)
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Heal All...", style: .plain, target: self, action: #selector(showMultiHealMenu)), animated: true)
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
            let location = wound.location.descriptiveText()
            let columnListing = ColumnListing(name: location,
                                              firstColumnValue: "\(wound.damageAmount)",
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
        let action = UIContextualAction(style: .destructive, title: "Remove") { (action, view, completion) in
            self.model.remove(wound) { (result) in
                switch result {
                case .success(let validity):
                    switch validity {
                    case .valid(let validationCompletion):
                        completion(true)
                        validationCompletion()
                    }
                default: completion(false)
                }
            }
        }
      
        action.backgroundColor = StyleConstants.Color.red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard model.wounds.indices.contains(indexPath.row) else { return nil }
        
        let wound = model.wounds[indexPath.row]
        let title = wound.traumaType == .CyberwareDamage ? "Repair" : "Heal"
        
        let action = UIContextualAction(style: .normal, title: title) { (action, view, completion) in
            self.repairAmount(title: "\(title) damage:") { _ in
                guard let damageReducerHelper = self.damageReducerHelper else { return }
                self.model.reduce(wound: wound, amount: damageReducerHelper.value) { (result) in
                    switch result {
                    case .success: completion(true)
                    default: completion(false)
                    }
                }
                self.damageReducerHelper = nil
            }
        }
      
        action.backgroundColor = StyleConstants.Color.blue
        return UISwipeActionsConfiguration(actions: [action])
    }
  
    
    // MARK: Private
    
    @objc private func showNewDamageEditor() {
        let editorViewController = EditorCollectionViewController(with: EditorCollectionViewModel.incomingDamage())
        editorViewController.delegate = self
        
        self.viewCoordinator?.viewControllerNeedsPresentation(vc: editorViewController)
    }
    
    @objc private func showMultiHealMenu() {
        let alert = UIAlertController(title: "Heals or repairs damage of a specific type.", message: nil, preferredStyle: .actionSheet)
        let healBluntAction = UIAlertAction(title: "Heal All Blunt Damage", style: .default) { _ in
            self.model.removeAll(.Blunt, validationCompletion: defaultCompletion)
        }
        let healFleshDamage = UIAlertAction(title: "Heal All Flesh Damage", style: .default) { _ in
            self.model.removeAll(.Blunt, validationCompletion: defaultCompletion)
            self.model.removeAll(.Burn, validationCompletion: defaultCompletion)
            self.model.removeAll(.Piercing, validationCompletion: defaultCompletion)
        }
        let healCyberWearAction = UIAlertAction(title: "Repair All CyberWare Damage", style: .default) { _ in
            self.model.removeAll(.CyberwareDamage, validationCompletion: defaultCompletion)
        }
        let healAllAction = UIAlertAction(title: "Remove All Damage", style: .destructive) { _ in
            self.model.wounds.forEach { wound in
                self.model.remove(wound, validationCompletion: { _ in })
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(healBluntAction)
        alert.addAction(healFleshDamage)
        alert.addAction(healCyberWearAction)
        alert.addAction(healAllAction)
        alert.addAction(cancel)
        
        // NEXT: FIX THE HEAL ALL BUTTONS NOT CLEARING THE WOUNDS IMMEDIATELY
        // ALSO FOR SOME REASON THE TOTAL DAMAGE STICKS AROUND IN THE LITTLE BOX ON THE MAIN SCREEN
        
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }
    
    @objc private func repairAmount(title: String, acceptHandler: @escaping (UIAlertAction) -> Void) {
        damageReducerHelper = DamageReducerHelper()
        
        let alert = UIAlertController(title: title, message: "Enter a positive integer", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.damageReducerHelper = nil
        }))
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: acceptHandler))

        alert.addTextField { [weak self] field in
            field.keyboardType = .numberPad
            field.delegate = self?.damageReducerHelper
        }
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }
    
}

private final class DamageReducerHelper: NSObject, UITextFieldDelegate {
    
    var value = 0
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let string = textField.text,
            let value = Int(string) else {
                return
        }
        
        self.value = value
    }
}
