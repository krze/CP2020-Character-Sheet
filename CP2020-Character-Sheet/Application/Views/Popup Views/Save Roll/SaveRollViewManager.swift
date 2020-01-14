//
//  SaveRollViewManager.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/13/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

final class SaveRollViewManager: NSObject, TableViewManaging {
    private var sections = [SaveRollTableSection: [AnyHashable]]()
    
    private let descriptionIdentifier = "description"
    private let rollsIdentifier = "rolls"
    
    init(description: String) {
        sections[.Description] = [description]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.keys.count
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SaveRollTableSection(rawValue: section) else {
            return 0
        }
        
        return sections[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SaveRollTableSection(rawValue: indexPath.section) else {
            return 0
        }
        
        switch section {
        case .Description:
            return 88
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SaveRollTableSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .Description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: descriptionIdentifier) else {
                return UITableViewCell()
            }
            
            cell.textLabel?.text = sections[section]?.first as? String
            cell.textLabel?.font = StyleConstants.Font.defaultFont
            cell.textLabel?.textAlignment = .center
            
            return cell
        case .Rolls:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: rollsIdentifier) as? SaveRollTableViewCell,
                let rolls = sections[section] as? [SaveRoll],
                rolls.indices.contains(indexPath.row) else {
                return UITableViewCell()
            }
            
            cell.setup(with: rolls[indexPath.row])
            
            return cell
        }
        
    }
    
    func registerCells(for tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: descriptionIdentifier)
        tableView.register(SaveRollTableViewCell.self, forCellReuseIdentifier: rollsIdentifier)
    }
    
    func appendRolls(_ rolls: [SaveRoll]) {
        sections[.Rolls] = rolls
    }
    
    private enum SaveRollTableSection: Int {
        case Description = 0, Rolls
    }
}
