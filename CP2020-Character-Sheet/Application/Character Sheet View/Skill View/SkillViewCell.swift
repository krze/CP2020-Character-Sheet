//
//  SkillViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class SkillViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Tableview fields
    
    private let rowCount = SkillTableConstants.highlightedSkillTableViewCellCount
    private let identifier = SkillTableConstants.identifier
    private let sectionCount = SkillTableConstants.highlightedSkillTableSectionCount

    private var viewModel: SkillViewCellModel?
//    private var highlightedSkillTableViewController: HighlightedSkillTableViewController?
    
    private var tableView = UITableView()
    
    func setup(viewModel: SkillViewCellModel) {
        self.viewModel = viewModel
        let safeFrame = contentView.safeAreaLayoutGuide.layoutFrame
        let cellDescriptionLabelFrame = CGRect(x: safeFrame.minX, y: safeFrame.minY,
                                               width: safeFrame.width * viewModel.cellDescriptionLabelWidthRatio,
                                               height: viewModel.cellDescriptionLabelHeight)
        let margins = NSDirectionalEdgeInsets(top: cellDescriptionLabelFrame.height * viewModel.cellDescriptionLabelPadding,
                                              leading: cellDescriptionLabelFrame.width * viewModel.cellDescriptionLabelPadding,
                                              bottom: cellDescriptionLabelFrame.height * viewModel.cellDescriptionLabelPadding,
                                              trailing: cellDescriptionLabelFrame.width * viewModel.cellDescriptionLabelPadding)
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
        
        tableView = UITableView(frame: highlightedTableViewFrame)
        
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = SkillTableConstants.rowHeight
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SkillTableViewCell.self, forCellReuseIdentifier: identifier)

        
        // debug
        tableView.backgroundColor = StyleConstants.Color.red
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cellDescriptionLabel.container.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.widthAnchor.constraint(equalToConstant: tableView.frame.width),
            tableView.heightAnchor.constraint(equalToConstant: tableView.frame.height)
            ])
    }
    
    private func descriptionLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = viewModel?.cellDescriptionLabelFont
        label.backgroundColor = viewModel?.darkColor
        label.textColor = viewModel?.lightColor
        label.text = viewModel?.cellDescriptionLabelText
        label.textAlignment = .center
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
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
    
    // MARK: UITableViewDataSource & UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        // DEBUG/PLACEHOLDER: This will have to be populated with skills
        
        if let cell = cell as? SkillTableViewCell {
            let skill = Skill(name: "Persuasion & Fast Talk",
                              nameExtension: nil,
                              description: "This is what you use to persuade people.",
                              isSpecialAbility: false,
                              linkedStat: "Intelligence",
                              modifiesSkill: nil,
                              IPMultiplier: 1)
            let skillListing = SkillListing(skill: skill, points: 5, modifier: 0, statModifier: 5)
            let viewModel = SkillTableViewCellModel()
            cell.setup(with: skillListing, viewModel: viewModel)
        }
        
        return cell
    }
}
