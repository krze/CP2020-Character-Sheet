//
//  HighlightedSkillTableViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A smaller, non-scrollable tablie view only containing the character's Special Ability
/// and 9 of their most powerful skills.
final class HighlightedSkillTableViewController: UITableViewController {
    private let identifier = SkillTableConstants.identifier

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = SkillTableConstants.rowHeight
        tableView.register(SkillTableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        // DEBUG/PLACEHOLDER: This will have to be populated with skills
        
        if let cell = cell as? SkillTableViewCell {
//            let skillListing
            cell.setup(with: <#T##SkillListing#>, viewModel: <#T##SkillTableViewCellModel#>)
        }

        return cell
    }
    
    // TODO: Custom init or setup function to pass in the skills to use in this view

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
