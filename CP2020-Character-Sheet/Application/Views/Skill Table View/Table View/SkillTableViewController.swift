//
//  SkillTableViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// The table view containing the full listing of every skill available to the player
final class SkillTableViewController: UITableViewController, SkillsDataSourceDelegate, UISearchResultsUpdating {

    private let dataSource: SkillsDataSource
    
    private let viewModel: SkillTableViewModel
    private let cellModel: ColumnTableViewCellModel
    
    private var sections = [SkillTableSections: [SkillListing]]()
    private let identifier = ColumnTableConstants.identifier
    
    private var skillListings = [SkillListing]()
    private var filteredSillListings = [SkillListing]()
    
    private let searchController = UISearchController(searchResultsController: nil)

    init(with skillsController: SkillsDataSource,
         viewModel: SkillTableViewModel,
         tableViewCellModel: ColumnTableViewCellModel) {
        self.dataSource = skillsController
        self.viewModel = viewModel
        cellModel = tableViewCellModel
        
        super.init(style: .plain)
        self.dataSource.delegate = self
        self.dataSource.getCharacterSkills()
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewSkillEditor)), animated: true)
        addObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ColumnTableViewCell.self, forCellReuseIdentifier: identifier)

        // Tableview Setup
        
        tableView.rowHeight = ColumnTableConstants.rowHeight
        tableView.backgroundColor = viewModel.lightColor
        
        // Search bar setup
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = SkillStrings.searchSkills
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isFiltering() {
            return 0.0
        }
        else {
            return ColumnTableConstants.headerHeight
            
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !isFiltering() else { return nil }
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: ColumnTableConstants.headerHeight)
        let labelText = SkillTableSections(rawValue: section)?.string() ?? SkillStrings.noAssociatedStat
        
        let model = ColumnTableViewModel(name: labelText,
                                         firstColumn: viewModel.pointsColumnLabelText,
                                         secondColumn: viewModel.modifierColumnLabelText,
                                         thirdColumn: viewModel.totalColumnLabelText)
        return ColumnTableViewHeader(viewModel: model, frame: frame)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? ColumnTableViewCell,
            let listing = skillListing(for: indexPath) {
            cell.prepare(with: listing.columnListing(), viewModel: cellModel)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let listing = skillListing(for: indexPath) {
            let viewModel = EditorCollectionViewModel.model(from: listing, mode: .edit, skillNameFetcher: dataSource.allSkillDisplayNames)
            showSkillDetail(viewModel: viewModel)
        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ColumnTableConstants.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let listing = skillListing(for: indexPath) else  { return nil }
        
        let action = UIContextualAction(style: .destructive, title: "Reset") { (action, view, completion) in
            self.resetConfirmation(title: "Are You Sure?",
                                   message: "Resetting the skill resets everything back to zero, including Improvement Points!",
                                   acceptHandler: { _ in
                                    self.dataSource.reset(listing) { (result) in
                                        switch result {
                                        case .success:
                                            completion(true)
                                        default:
                                            completion(false)
                                        }
                                    }
            },
                                   rejectHandler: { _ in
                                    completion(true)
                
            })
        }
        
        action.backgroundColor = StyleConstants.Color.red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let listing = skillListing(for: indexPath) else  { return nil }
        let title = listing.starred ? "Untag" : "Tag"
        let action = UIContextualAction(style: .normal, title: title) { (action, view, completion) in
            self.dataSource.flipStar(listing) { (result) in
                switch result {
                case .success:
                    completion(true)
                default:
                    completion(false)
                }
            }
        }
        
        action.backgroundColor = listing.starred ?  StyleConstants.Color.gray : StyleConstants.Color.blue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // MARK: - UITableViewDataSource
    
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
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text)
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func filterContentForSearchText(_ searchText: String?, scope: String = "All") {
        guard let searchText = searchText else { return }
        
        filteredSillListings = skillListings.filter({ skill in
            let searchText = searchText.lowercased()
            let skillName = skill.skill.name.lowercased()
            let skillExtension = skill.skill.nameExtension
            
            let skillNameMatch = skillName.contains(searchText)
            let extensionNameMatch = skillExtension?.contains(searchText) == true
            let skillAndExtensionMatch = skill.displayName().contains(searchText)
            
            return skillNameMatch || extensionNameMatch || skillAndExtensionMatch
        })
        updateSections()
        tableView.reloadData()
    }
    
    private func refreshTableAfterHeightChange() {
        tableView.beginUpdates()
        tableView.setNeedsDisplay()
        tableView.endUpdates()
    }
    
    private func headerLabel(frame: CGRect, text: String, font: UIFont?, backgroundColor: UIColor) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = backgroundColor
        label.textColor = viewModel.lightColor
        label.text = text
        label.textAlignment = .left
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return label
    }

    /// Refreshes the sections dictionary. This is a O(1) operation.
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
        var skillListings = isFiltering() ? self.filteredSillListings : self.skillListings
        
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
        tableView.reloadData()
    }
    
    @objc private func showNewSkillEditor() {
        showSkillDetail(viewModel: EditorCollectionViewModel.modelForBlankSkill(skillNameFetcher: dataSource.allSkillDisplayNames))
    }
    
    private func showSkillDetail(viewModel: EditorCollectionViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let skillDetail = EditorCollectionViewController(with: viewModel)
            skillDetail.delegate = self.dataSource
            NotificationCenter.default.post(name: .showEditor, object: skillDetail)
        }
    }
    
    private func skillListing(for indexPath: IndexPath) -> SkillListing? {
        if let section = SkillTableSections(rawValue: indexPath.section) {
            return sections[section]?[indexPath.row]
        }
        
        return nil
    }
    
    private func resetConfirmation(title: String, message: String,
                                   acceptHandler: @escaping (UIAlertAction) -> Void,
                                   rejectHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: AlertViewStrings.confirmButtonTitle, style: .destructive, handler: acceptHandler))
        alert.addAction(UIAlertAction(title: AlertViewStrings.rejectButtonTitle, style: .cancel, handler: rejectHandler))
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
