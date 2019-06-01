//
//  SkillTableViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// The table view containing the full listing of every skill available to the player
final class SkillTableViewController: UITableViewController, SkillsDataSourceDelegate, SkillTableViewCellDelegate {

    private let dataSource: SkillsDataSource
    
    private let viewModel: SkillTableViewModel
    private let cellModel: SkillTableViewCellModel
    
    private var sections = [SkillTableSections: [SkillListing]]()
    private let identifier = SkillTableConstants.identifier
    
    private var skillListings = [SkillListing]()
    
    // MARK: Cell expansion
    
    private var expandedRowHeight: CGFloat
    private var selectedIndex: IndexPath?

    init(with skillsController: SkillsDataSource,
         viewModel: SkillTableViewModel,
         tableViewCellModel: SkillTableViewCellModel) {
        self.dataSource = skillsController
        self.viewModel = viewModel
        self.expandedRowHeight = SkillTableConstants.rowHeight * 4
        cellModel = tableViewCellModel
        
        super.init(style: .plain)
        self.dataSource.delegate = self
        self.dataSource.getCharacterSkills()
        addObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SkillTableViewCell.self, forCellReuseIdentifier: identifier)

        tableView.rowHeight = SkillTableConstants.rowHeight
        tableView.sectionHeaderHeight = SkillTableConstants.rowHeight
        tableView.backgroundColor = viewModel.lightColor
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SkillTableConstants.rowHeight)
        let labelText = SkillTableSections(rawValue: section)?.string() ?? "No Associated Stat"
        
        let view = UIView(frame: frame)
        view.backgroundColor = viewModel.darkColor
        view.directionalLayoutMargins = viewModel.createInsets(with: frame)
        let labelFrame = CGRect(x: view.frame.minX,
                                y: view.frame.minY,
                                width: view.frame.width - view.directionalLayoutMargins.leading - view.directionalLayoutMargins.trailing,
                                height: view.frame.height - view.directionalLayoutMargins.top - view.directionalLayoutMargins.bottom)
        let label = headerLabel(frame: labelFrame, text: labelText)
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: labelFrame.width),
            label.heightAnchor.constraint(equalToConstant: labelFrame.height),
            label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
            ])
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? SkillTableViewCell, let section = SkillTableSections(rawValue: indexPath.section),
            let listing = sections[section]?[indexPath.row] {
            cell.prepare(with: listing, viewModel: cellModel)
            cell.delegate = self
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = self.tableView.cellForRow(at: indexPath) as? SkillTableViewCell else {
            return
        }
        
        if let listing = cell.skillListing {
            let viewModel = EditorCollectionViewModel.model(from: listing)
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 0
            showSkillDetail(viewModel: viewModel)
        }

//        // Deselect
//        if selectedIndex == indexPath {
//            selectedIndex = nil
//            cell.hideDescription()
//        }
//        else {
//            // Select
//
//            // Already selected cells need to collapse
//            if let selectedIndex = selectedIndex,
//                let selectedCell = self.tableView.cellForRow(at: selectedIndex) as? SkillTableViewCell {
//                self.selectedIndex = nil
//                selectedCell.hideDescription()
//            }
//
//            // Select new index
//            selectedIndex = indexPath
//            cell.showDescription()
//        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndex == indexPath {
            return expandedRowHeight
        }
        else{
            return SkillTableConstants.rowHeight
        }
    }
    
    // MARK: - TableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = SkillTableSections(rawValue: section) {
            return sections[section]?.count ?? 0
        }
        
        return 0
    }
    
    // MARK: SkillsDataSourceDelegate
    
    func skillsDidUpdate(skills: [SkillListing]) {
        skillListings = skills
        updateSections()
        tableView.reloadData()
    }
    
    
    // MARK: SkillTableViewCellDelegate
    
    func cellHeightDidChange(_ cell: SkillTableViewCell) {
        if let rowHeight = cell.heightForDescriptionAboutToDisplay() {
            expandedRowHeight = rowHeight + SkillTableConstants.rowHeight
        }
        
        refreshTableAfterHeightChange()
    }
    
    private func refreshTableAfterHeightChange() {
        tableView.beginUpdates()
        tableView.setNeedsDisplay()
        tableView.endUpdates()
    }
    
    private func headerLabel(frame: CGRect, text: String) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = viewModel.headerFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = viewModel.darkColor
        label.textColor = viewModel.lightColor
        label.text = text
        label.textAlignment = .left
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return label
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
            .Empathy: [SkillListing](),
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
        
        sections.forEach { (key, value) in
            let sortedListing = value.sorted { (first, next) -> Bool in
                return first.skill.name < next.skill.name
            }
            
            sections[key] = sortedListing
        }
        
        self.sections = sections
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(forceRefresh), name: .statsDidChange, object: nil)
    }
    
    @objc private func forceRefresh() {
        /// Ensures descriptions are hid again in case they were left open
        if let indexPath = selectedIndex,
            let cell = self.tableView.cellForRow(at: indexPath) as? SkillTableViewCell {
            cell.hideDescription()
            selectedIndex = nil
        }
        
        tableView.reloadData()
    }
    
    private func showSkillDetail(viewModel: EditorCollectionViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let skillDetail = EditorCollectionViewController(with: viewModel)
            self.navigationController?.pushViewController(skillDetail, animated: true)
        }
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
