//
//  SkillTableViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// The table view containing the full listing of every skill available to the player
final class SkillTableViewController: UITableViewController, SkillsDataSourceDelegate, SkillTableViewCellDelegate, UISearchResultsUpdating {

    private let dataSource: SkillsDataSource
    
    private let viewModel: SkillTableViewModel
    private let cellModel: SkillTableViewCellModel
    
    private var sections = [SkillTableSections: [SkillListing]]()
    private let identifier = SkillTableConstants.identifier
    
    private var skillListings = [SkillListing]()
    private var filteredSillListings = [SkillListing]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewSkillEditor)), animated: true)
        addObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SkillTableViewCell.self, forCellReuseIdentifier: identifier)

        // Tableview Setup
        
        tableView.rowHeight = SkillTableConstants.rowHeight
        tableView.backgroundColor = viewModel.lightColor
        
        // Search bar setup
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = SkillStrings.searchSkills
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isFiltering() {
            return 0.0
        }
        else {
            return SkillTableConstants.rowHeight
            
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !isFiltering() else { return nil }
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SkillTableConstants.rowHeight)
        let labelText = SkillTableSections(rawValue: section)?.string() ?? SkillStrings.noAssociatedStat
        
        let view = UIView(frame: frame)
        view.backgroundColor = viewModel.darkColor
        view.directionalLayoutMargins = viewModel.createInsets(with: frame)
        let labelFrame = CGRect(x: view.frame.minX,
                                y: view.frame.minY,
                                width: view.frame.width - view.directionalLayoutMargins.leading - view.directionalLayoutMargins.trailing,
                                height: view.frame.height - view.directionalLayoutMargins.top - view.directionalLayoutMargins.bottom)
        let label = headerLabel(frame: labelFrame, text: labelText, font: viewModel.headerFont, backgroundColor: viewModel.darkColor)
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: labelFrame.width),
            label.heightAnchor.constraint(equalToConstant: labelFrame.height),
            label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
            ])
        
        let headerFrame = view.frame
        var trailingAnchor = view.trailingAnchor
        let columnLabelTexts = [viewModel.totalColumnLabelText,
                                viewModel.modifierColumnLabelText,
                                viewModel.pointsColumnLabelText]
        
        columnLabelTexts.enumerated().forEach { index, text in
            let width = headerFrame.width * viewModel.columnLabelWidthRatio
            let frame = CGRect(x: headerFrame.maxX - (width * CGFloat(index)),
                               y: headerFrame.minY,
                               width: width,
                               height: SkillTableConstants.rowHeight)
            let margins = viewModel.createInsets(with: frame)
            let backgroundColor = StyleConstants.Color.dark
            
            func columnLabel(frame: CGRect) -> UILabel {
                let label = self.headerLabel(frame: frame, text: text, font: viewModel.columnLabelFont, backgroundColor: backgroundColor)
                label.textAlignment = .center
                label.font = viewModel.columnLabelFont?.withSize(viewModel.columnLabelMaxTextSize)
                return label
            }
            
            let columnView = UILabel.container(frame: frame, margins: margins, backgroundColor: backgroundColor, borderColor: nil, borderWidth: nil, labelMaker: columnLabel)
            
            view.addSubview(columnView.container)
            
            NSLayoutConstraint.activate([
                columnView.container.topAnchor.constraint(equalTo: view.topAnchor),
                columnView.container.trailingAnchor.constraint(equalTo: trailingAnchor),
                columnView.container.widthAnchor.constraint(equalToConstant: frame.width),
                columnView.container.heightAnchor.constraint(equalToConstant: frame.height)
                ])
            
            trailingAnchor = columnView.container.leadingAnchor
        }
        
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
            let viewModel = EditorCollectionViewModel.model(from: listing, mode: .edit, skillNameFetcher: dataSource.allSkillDisplayNames)
            showSkillDetail(viewModel: viewModel)
        }

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
        /// Ensures descriptions are hid again in case they were left open
        if let indexPath = selectedIndex,
            let cell = self.tableView.cellForRow(at: indexPath) as? SkillTableViewCell {
            cell.hideDescription() // TODO: Decide to axe this or keep this.
            selectedIndex = nil
        }
        
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
            self.navigationController?.pushViewController(skillDetail, animated: true)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
