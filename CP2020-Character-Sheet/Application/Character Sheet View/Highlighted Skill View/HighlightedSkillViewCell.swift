//
//  HighlightedSkillViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class HighlightedSkillViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Tableview fields
    
    private let rowCount = SkillTableConstants.highlightedSkillTableViewCellCount
    private let identifier = SkillTableConstants.identifier
    private let sectionCount = SkillTableConstants.highlightedSkillTableSectionCount

    private var viewModel: HighlightedSkillViewCellModel?
    private var tableView = UITableView()
    
    func setup(viewModel: HighlightedSkillViewCellModel) {
        self.viewModel = viewModel
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
            let backgroundColor = index % 2 > 0 ? StyleConstants.Color.light : StyleConstants.Color.gray
            
            func columnLabel(frame: CGRect) -> UILabel {
                return self.columnLabel(frame: frame, text: text, backgroundColor: backgroundColor)
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
        tableView.rowHeight = SkillTableConstants.rowHeight
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
        label.textAlignment = .left
        label.fitTextToBounds(maximumSize: viewModel?.columnLabelMaxTextSize)
        
        return label
    }
    
    private func columnLabel(frame: CGRect, text: String, backgroundColor: UIColor) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = viewModel?.columnLabelFont
        label.backgroundColor = backgroundColor
        label.textColor = viewModel?.darkColor
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
            cell.prepareForFirstTimeSetup(with: skillListing, viewModel: viewModel)
        }
        
        return cell
    }
}
