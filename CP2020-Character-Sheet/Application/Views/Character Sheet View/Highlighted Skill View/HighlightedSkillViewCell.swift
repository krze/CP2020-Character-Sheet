//
//  HighlightedSkillViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class HighlightedSkillViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate, UsedOnce, SkillsDataSourceDelegate, ViewCreating {
    
    private (set) var wasSetUp: Bool = false
    
    private var dataSource: HighlightedSkillViewCellDataSource?
    private weak var skillsTableDataSource: SkillsDataSource?
    
    // MARK: Tableview fields
    
    private let rowCount = SkillTableConstants.highlightedSkillTableViewCellCount
    private let identifier = ColumnTableConstants.identifier
    private let sectionCount = SkillTableConstants.highlightedSkillTableSectionCount

    private var viewModel: HighlightedSkillViewCellModel?
    private var tableView = UITableView()
    
    private var highlightedSkills = [SkillListing]()
    
    var viewCoordinator: ViewCoordinating?

    func setup(viewModel: HighlightedSkillViewCellModel) {
        if wasSetUp {
            dataSource?.refreshData()
            return
        }
        self.viewModel = viewModel
        
        createObservers()

        if self.dataSource == nil {
            highlightedSkills = blankSkills(withCount: rowCount)
        }
        else {
            self.dataSource?.delegate = self
        }
        
        let safeFrame = contentView.safeAreaLayoutGuide.layoutFrame
        let cellDescriptionLabelFrame = CGRect(x: safeFrame.minX, y: safeFrame.minY,
                                               width: safeFrame.width,
                                               height: viewModel.cellDescriptionLabelHeight)
        let columnTableViewModel = ColumnTableViewModel(name: viewModel.cellDescriptionLabelText,
                                                        firstColumn: viewModel.pointsColumnLabelText,
                                                        secondColumn: viewModel.modifierColumnLabelText,
                                                        thirdColumn: viewModel.totalColumnLabelText)
        let cellDescriptionLabel = ColumnTableViewHeader(viewModel: columnTableViewModel, frame: cellDescriptionLabelFrame)
        
        cellDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellDescriptionLabel)
        
        NSLayoutConstraint.activate([
            cellDescriptionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cellDescriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            cellDescriptionLabel.widthAnchor.constraint(equalToConstant: cellDescriptionLabelFrame.width),
            cellDescriptionLabel.heightAnchor.constraint(equalToConstant: cellDescriptionLabelFrame.height)
            ])
        
        let highlightedTableViewFrame = CGRect(x: safeFrame.minX,
                                               y: safeFrame.minY + cellDescriptionLabelFrame.height,
                                               width: safeFrame.width,
                                               height: safeFrame.height - cellDescriptionLabelFrame.height)

        tableView = UITableView(frame: highlightedTableViewFrame)
        
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.rowHeight = ColumnTableConstants.rowHeight
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ColumnTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cellDescriptionLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.widthAnchor.constraint(equalToConstant: tableView.frame.width),
            tableView.heightAnchor.constraint(equalToConstant: tableView.frame.height)
            ])
        
        setupGestureRecognizers()
        wasSetUp = true
    }
    
    /// Adds the datasource and refreshes data
    ///
    /// - Parameter dataSource: The HighlightedSkillViewCellDataSource
    func update(dataSource: SkillsDataSource) {
        self.skillsTableDataSource = dataSource
        self.dataSource = dataSource.highlightedSkillsDataSource()
        self.dataSource?.delegate = self
        self.dataSource?.refreshData()
    }
    
    // MARK: UITableViewDataSource & UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highlightedSkills.count < rowCount ? highlightedSkills.count : rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? ColumnTableViewCell {
            let listing = highlightedSkills[indexPath.row]
            cell.prepare(with: listing.columnListing(), viewModel: ColumnTableViewCellModel())
        }
        
        return cell
    }
    
    // MARK: SkillsDataSourceDelegate
    
    func skillsDidUpdate(skills: [SkillListing]) {
        highlightedSkills = skills
        tableView.reloadData()
    }
    
    // MARK: Private
    
    private func showSkillTable(with dataSource: SkillsDataSource) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let skillTableViewController = SkillTableViewController(with: dataSource,
                                                                    viewModel: SkillTableViewModel(),
                                                                    tableViewCellModel: ColumnTableViewCellModel())
            let modalView = UINavigationController(rootViewController: skillTableViewController)
            
            self.viewCoordinator?.viewControllerNeedsPresentation(vc: modalView)
        }
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(forceRefresh), name: .roleDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(forceRefresh), name: .skillDidChange, object: nil)
    }
    
    private func setupGestureRecognizers() {
        // Single tap on the entire cell
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(HighlightedSkillViewCell.cellTapped))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTouchesRequired = 1
        contentView.addGestureRecognizer(singleTap)
    }
    
    @objc private func cellTapped() {
        guard let dataSource = skillsTableDataSource else { return }
        showSkillTable(with: dataSource)
    }
    
    private func descriptionLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = viewModel?.cellDescriptionLabelFont
        label.backgroundColor = viewModel?.darkColor
        label.textColor = viewModel?.lightColor
        label.text = viewModel?.cellDescriptionLabelText
        label.textAlignment = .left
        label.fitTextToBounds(maximumSize: viewModel?.columnLabelMaxTextSize)
        
        return label
    }
    
    private func columnLabel(frame: CGRect, text: String, backgroundColor: UIColor) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = viewModel?.columnLabelFont
        label.backgroundColor = backgroundColor
        label.textColor = viewModel?.lightColor
        label.text = text
        label.textAlignment = .center
        label.fitTextToBounds(maximumSize: viewModel?.columnLabelMaxTextSize)
        
        return label
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = StyleConstants.Color.light
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This initializer is not supported.")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("Interface Builder is not supported!")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // TODO: Test cell re-use and see if it needs anything here
    }
    
    private func blankSkills(withCount count: Int) -> [SkillListing] {
        var skills = [SkillListing]()
        for _ in 1...count {
            let loadingSkill = Skill(name: "Skills loading... ", nameExtension: nil, description: "", isSpecialAbility: false, linkedStat: nil, modifiesSkill: nil, IPMultiplier: 1)
            let loadingSkillListing = SkillListing(skill: loadingSkill, points: 0, modifier: 0, statModifier: 0)
            skills.append(loadingSkillListing)
        }
        
        return skills
    }
    
    @objc private func forceRefresh() {
        self.dataSource?.refreshData()
        tableView.reloadData()
    }
    
}
