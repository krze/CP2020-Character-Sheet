//
//  ColumnTableViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// UITableViewCell which contains space for a name, and 3 columns.
final class ColumnTableViewCell: UITableViewCell {
        
    // MARK: Fields for the cell
    
    private var name: UILabel?
    private var firstColumn: UILabel?
    private var secondColumn: UILabel?
    private var thirdColumn: UILabel?
    private let stack = UIStackView()
    private var topView: UIView?
    
    private var viewModel: ColumnTableViewCellModel?
    private(set) var skillListing: SkillListing?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight

        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        let topView = topViewContainer()
        stack.addArrangedSubview(topView)
        
        let topViewHeightConstraint = topView.heightAnchor.constraint(equalToConstant: SkillTableConstants.rowHeight)
        topViewHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stack.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            topView.topAnchor.constraint(equalTo: stack.topAnchor),
            topViewHeightConstraint,
            ])
        
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 0
        
        self.topView = topView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets up the view with the SkillListing provided. This function is intended for first-time setup.
    /// Use this as as second-stage initializer after creating the cell in a table view with a reuse identifier.
    ///
    /// - Parameters:
    ///   - skillListing: SkillListing corresponding with the table view cell
    ///   - viewModel: The cell's view model
    func prepare(with skillListing: SkillListing, viewModel: ColumnTableViewCellModel) {
        if self.skillListing != nil {
            update(skillListing: skillListing)
        }
        else {
            self.viewModel = viewModel
            self.skillListing = skillListing
        }
    }
    
    /// Updates the skill listing. This can be called at any time to change the values displayed.
    ///
    /// - Parameter skillListing: The skill listing to display
    func update(skillListing: SkillListing) {
        self.skillListing = skillListing
        updateColumnValues()
    }
    
    /// Update the skill listing for the table view.
    private func updateColumnValues() {
        guard let viewModel = viewModel, let skillListing = skillListing else { return }
        self.backgroundColor = StyleConstants.Color.light
        
        self.name?.text = skillListing.displayName()
        self.name?.font = viewModel.nameFont
        self.name?.textAlignment = .left
        self.name?.fitTextToBounds(maximumSize: viewModel.fontSize)
        
        firstColumn?.text = "\(skillListing.points)"
        firstColumn?.font = viewModel.columnFontRegular
        firstColumn?.textAlignment = .center
        firstColumn?.fitTextToBounds(maximumSize: viewModel.fontSize)
        
        secondColumn?.text = "\(skillListing.modifier)"
        secondColumn?.font = viewModel.columnFontRegular
        secondColumn?.textAlignment = .center
        secondColumn?.fitTextToBounds(maximumSize: viewModel.fontSize)
        
        thirdColumn?.text = "\(skillListing.skillRollValue)"
        thirdColumn?.font = viewModel.columnFontBold
        thirdColumn?.textAlignment = .center
        thirdColumn?.fitTextToBounds(maximumSize: viewModel.fontSize)
    }
    
    private func columnLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = StyleConstants.Color.dark
        label.font = StyleConstants.Font.defaultFont
        label.text = "0"
        label.fitTextToBounds()
        
        return label
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateColumnValues()
    }
    
    /// This is a one-time called second stage initializer
    private func topViewContainer() -> UIView {
        let nameCellWidthRatio = CGFloat(0.55) // 55% of view width
        let detailCellWidthRatio = CGFloat(0.15) // 3 cells, 15% of width each
        
        let safeFrame = contentView.frame
        let totalWidth = safeFrame.width
        
        let topViewContainer = UIView()
        
        topViewContainer.translatesAutoresizingMaskIntoConstraints = false
        // MARK: Name column construction
        
        let nameFrameWidth = totalWidth * nameCellWidthRatio
        let nameFrame = CGRect(x: safeFrame.minX, y: safeFrame.minY,
                               width: nameFrameWidth, height: SkillTableConstants.rowHeight)
        let nameMargins = NSDirectionalEdgeInsets(top: nameFrame.height * 0.05,
                                                  leading: nameFrame.width * 0.05,
                                                  bottom: nameFrame.height * 0.05,
                                                  trailing: nameFrame.width * 0.05)
        
        let nameView = UILabel.container(frame: nameFrame,
                                         margins: nameMargins,
                                         backgroundColor: StyleConstants.Color.light,
                                         borderColor: nil, borderWidth: nil,
                                         labelMaker: columnLabel)
        name = nameView.label
        topViewContainer.addSubview(nameView.container)
        
        NSLayoutConstraint.activate([
            nameView.container.leadingAnchor.constraint(equalTo: topViewContainer.leadingAnchor),
            nameView.container.topAnchor.constraint(equalTo: topViewContainer.topAnchor),
            nameView.container.widthAnchor.constraint(equalToConstant: nameFrameWidth),
            nameView.container.heightAnchor.constraint(equalToConstant: SkillTableConstants.rowHeight)
            ])
        
        // MARK: detail Column Construction
        
        var trailingAnchor = topViewContainer.trailingAnchor
        var count = 0
        
        for detailColumn in 1...3 {
            let detailFrameWidth = totalWidth * detailCellWidthRatio
            let detailFrame = CGRect(x: nameFrameWidth + (detailFrameWidth * CGFloat(count)),
                                      y: safeFrame.minY,
                                      width: detailFrameWidth,
                                      height: safeFrame.height)
            let detailMargins = NSDirectionalEdgeInsets(top: detailFrame.height * 0.05,
                                                         leading: detailFrame.width * 0.05,
                                                         bottom: detailFrame.height * 0.05,
                                                         trailing: detailFrame.width * 0.05)
            let backgroundColor = detailColumn % 2 > 0 ? StyleConstants.Color.gray : StyleConstants.Color.light
            let detailView = UILabel.container(frame: detailFrame,
                                                margins: detailMargins,
                                                backgroundColor: backgroundColor,
                                                borderColor: nil, borderWidth: nil,
                                                labelMaker: columnLabel)
            
            detailView.label.backgroundColor = backgroundColor
            
            // Store the labels on the object to be edited by the update function
            switch detailColumn {
            case 3:
                firstColumn = detailView.label
            case 2:
                secondColumn = detailView.label
            case 1:
                thirdColumn = detailView.label
            default:
                break
            }
            
            topViewContainer.addSubview(detailView.container)
            
            NSLayoutConstraint.activate([
                detailView.container.trailingAnchor.constraint(equalTo: trailingAnchor),
                detailView.container.topAnchor.constraint(equalTo: topViewContainer.topAnchor),
                detailView.container.widthAnchor.constraint(equalTo: topViewContainer.widthAnchor, multiplier: detailCellWidthRatio),
                detailView.container.heightAnchor.constraint(equalToConstant: SkillTableConstants.rowHeight)
                ])
            
            trailingAnchor = detailView.container.leadingAnchor
            count += 1
        }
        return topViewContainer
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateColumnValues()
    }
    
}
