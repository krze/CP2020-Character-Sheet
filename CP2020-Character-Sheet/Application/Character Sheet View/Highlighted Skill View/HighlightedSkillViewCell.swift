//
//  HighlightedSkillViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class HighlightedSkillViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate, UsedOnce, SkillsDataSourceDelegate {
    
    private (set) var wasSetUp: Bool = false
    
    private var dataSource: HighlightedSkillViewCellDataSource?
    
    // MARK: Tableview fields
    
    private let rowCount = SkillTableConstants.highlightedSkillTableViewCellCount
    private let identifier = SkillTableConstants.identifier
    private let sectionCount = SkillTableConstants.highlightedSkillTableSectionCount

    private var viewModel: HighlightedSkillViewCellModel?
    private var tableView = UITableView()
    
    private var highlightedSkills = [SkillListing]()
    
    func setup(viewModel: HighlightedSkillViewCellModel, dataSource: HighlightedSkillViewCellDataSource?) {
        if wasSetUp {
            dataSource?.refreshData()
            return
        }
        self.viewModel = viewModel
        self.dataSource = dataSource
        
        createObservers()

        if self.dataSource == nil {
            highlightedSkills = blankSkills(withCount: rowCount)
        }
        else {
            self.dataSource?.delegate = self
        }
        
        let safeFrame = contentView.safeAreaLayoutGuide.layoutFrame
        let cellDescriptionLabelFrame = CGRect(x: safeFrame.minX, y: safeFrame.minY,
                                               width: safeFrame.width * viewModel.cellDescriptionLabelWidthRatio,
                                               height: viewModel.cellDescriptionLabelHeight)
        let margins = viewModel.createInsets(with: cellDescriptionLabelFrame)
        let cellDescriptionLabel = UILabel.container(frame: cellDescriptionLabelFrame,
                                                     margins: margins,
                                                     backgroundColor: viewModel.darkColor,
                                                     borderColor: nil, borderWidth: nil,
                                                     labelMaker: descriptionLabel)
        cellDescriptionLabel.container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellDescriptionLabel.container)
        
        NSLayoutConstraint.activate([
            cellDescriptionLabel.container.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cellDescriptionLabel.container.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            cellDescriptionLabel.container.widthAnchor.constraint(equalToConstant: cellDescriptionLabelFrame.width),
            cellDescriptionLabel.container.heightAnchor.constraint(equalToConstant: cellDescriptionLabelFrame.height)
            ])
        
        let highlightedTableViewFrame = CGRect(x: safeFrame.minX,
                                               y: safeFrame.minY + cellDescriptionLabelFrame.height,
                                               width: safeFrame.width,
                                               height: safeFrame.height - cellDescriptionLabelFrame.height)
        
        var trailingAnchor = contentView.trailingAnchor
        let columnLabelTexts = [viewModel.totalColumnLabelText,
                                viewModel.modifierColumnLabelText,
                                viewModel.pointsColumnLabelText]
        
        columnLabelTexts.enumerated().forEach { index, text in
            let width = safeFrame.width * viewModel.columnLabelWidthRatio
            let frame = CGRect(x: safeFrame.maxX - (width * CGFloat(index)),
                               y: safeFrame.minY,
                               width: width,
                               height: viewModel.cellDescriptionLabelHeight)
            let margins = viewModel.createInsets(with: frame)
            let backgroundColor = StyleConstants.Color.dark
            
            func columnLabel(frame: CGRect) -> UILabel {
                let label = self.columnLabel(frame: frame, text: text, backgroundColor: backgroundColor)
                label.textAlignment = .center
                label.font = viewModel.columnLabelFont?.withSize(viewModel.columnLabelMaxTextSize)
                return label
            }
            
            let columnView = UILabel.container(frame: frame, margins: margins, backgroundColor: backgroundColor, borderColor: nil, borderWidth: nil, labelMaker: columnLabel)
            
            contentView.addSubview(columnView.container)
            
            NSLayoutConstraint.activate([
                columnView.container.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                columnView.container.trailingAnchor.constraint(equalTo: trailingAnchor),
                columnView.container.widthAnchor.constraint(equalToConstant: frame.width),
                columnView.container.heightAnchor.constraint(equalToConstant: frame.height)
                ])
            
            trailingAnchor = columnView.container.leadingAnchor
        }
        
        tableView = UITableView(frame: highlightedTableViewFrame)
        
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.rowHeight = SkillTableConstants.rowHeight
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SkillTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cellDescriptionLabel.container.bottomAnchor),
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
    func update(dataSource: HighlightedSkillViewCellDataSource) {
        self.dataSource = dataSource
        self.dataSource?.delegate = self
        self.dataSource?.refreshData()
    }
    
    // MARK: UITableViewDataSource & UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highlightedSkills.count < rowCount ? highlightedSkills.count : rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? SkillTableViewCell {
            let listing = highlightedSkills[indexPath.row]
            cell.prepare(with: listing, viewModel: SkillTableViewCellModel())
        }
        
        return cell
    }
    
    // MARK: SkillsDataSourceDelegate
    
    func skillsDidUpdate(skills: [SkillListing]) {
        highlightedSkills = skills
        tableView.reloadData()
    }
    
    // MARK: Private
    
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
        NotificationCenter.default.post(name: .showSkillTable, object: nil)
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
            let loadingSkill = Skill(name: "Skills loading... ", nameExtension: nil, description: "", isSpecialAbility: false, linkedStat: nil, modifiesSkill: nil, IPMultiplier: 0)
            let loadingSkillListing = SkillListing(skill: loadingSkill, points: 0, modifier: 0, statModifier: 0)
            skills.append(loadingSkillListing)
        }
        
        return skills
    }
    
    @objc private func forceRefresh() {
        self.dataSource?.refreshData()
    }
    
}
