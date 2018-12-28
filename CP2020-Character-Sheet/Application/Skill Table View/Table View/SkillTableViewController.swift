//
//  SkillTableViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// The table view containing the full listing of every skill available to the player
final class SkillTableViewController: UITableViewController, SkillsControllerDelegate {

    private let skillsController: SkillsController
    
    private let viewModel: SkillTableViewModel
    private let cellModel: SkillTableViewCellModel
    
    private var sections = [SkillTableSections: [SkillListing]]()
    private let identifier = SkillTableConstants.identifier
    
    private var skillListings = [SkillListing]()

    init(with skillsController: SkillsController,
         viewModel: SkillTableViewModel,
         tableViewCellModel: SkillTableViewCellModel) {
        self.skillsController = skillsController
        self.viewModel = viewModel
        cellModel = tableViewCellModel
        
        super.init(style: .plain)
        self.skillsController.delegate = self
        self.skillsController.getCharacterSkills()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SkillTableViewCell.self, forCellReuseIdentifier: identifier)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = SkillTableConstants.rowHeight
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = SkillTableSections(rawValue: section) {
            return sections[section]?.count ?? 0
        }
        
        return 0
    }
    
    // MARK: SkillsControllerDelegate
    
    func skillsDidUpdate(skills: [SkillListing]) {
        skillListings = skills
        updateSections()
        tableView.reloadData()
    }
    
    
    /// Reflreshes the sections dictionary. This is a O(1) operation.
    ///
    /// This function does not take into account skills that are not special abilities that have no linked
    /// stats. This controller is expected to recieve a filtered array of stats relevent to the character's
    /// role to begin with, so only one Special Ability will be chosen from the skills.
    private func updateSections() {
        var sections: [SkillTableSections: [SkillListing]] = [
            .SpecialAbility: [SkillListing](),
            .Attractiveness: [SkillListing](),
            .Body: [SkillListing](),
            .Cool: [SkillListing](),
            .Intelligence: [SkillListing](),
            .Reflex: [SkillListing](),
            .Tech: [SkillListing]()
            ]
        
        if let specialIndex = skillListings.firstIndex(where: { $0.skill.isSpecialAbility }) {
            sections[.SpecialAbility] = [skillListings.remove(at: specialIndex)]
        }
        
        while !skillListings.isEmpty {
            if let listing = skillListings.popLast(),
                let linkedStat = listing.skill.linkedStat {
                sections[SkillTableSections.section(for: linkedStat)]?.append(listing)
            }
        }
        
        self.sections = sections
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SkillTableConstants.rowHeight)
        let margins = viewModel.createInsets(with: frame)
        let labelText = SkillTableSections(rawValue: section)?.string() ?? "No Associated Stat"
        
        func labelMaker(frame: CGRect) -> UILabel {
            return headerLabel(frame: frame, text: labelText)
        }
        
        let view = UILabel.container(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SkillTableConstants.rowHeight), margins: margins, backgroundColor: viewModel.darkColor, borderColor: nil, borderWidth: nil, labelMaker: labelMaker)
        
        return view.container
    }
    
    private func headerLabel(frame: CGRect, text: String) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = viewModel.headerFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = viewModel.darkColor
        label.textColor = viewModel.lightColor
        label.text = text
        label.textAlignment = .center
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if let cell = cell as? SkillTableViewCell, let section = SkillTableSections(rawValue: indexPath.section), let listing = sections[section]?[indexPath.row] {
            cell.prepareForFirstTimeSetup(with: listing, viewModel: cellModel)
        }
        
        return cell
    }
    
    private func createObservers() {
        // TODO: Set up observers for the following:
        //        skillPointsDidChange
        //        statsDidChange (maybe? I dont think this controller will be alive during this notification)
        //        roleDidChange (maybe? See above)
        //        newSkillAdded
        //        improvementPointsAdded
        //        skillPointModifierDidChange
        //        skillPointStatModifierDidChange
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
