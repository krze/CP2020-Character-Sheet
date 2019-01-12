//
//  SkillTableViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Custom UITableViewCell which shows a skill listing in unlabeled columns.
final class SkillTableViewCell: UITableViewCell {
    
    weak var delegate: SkillTableViewCellDelegate?
    
    // MARK: Fields for the cell
    
    private var name: UILabel?
    private var points: UILabel?
    private var modifier: UILabel?
    private var total: UILabel?
    private let stack = UIStackView()
    
    private var topView: UIView?
    private var bottomView: UIView?
    
    private var skillDescription: UITextView?
    
    private var viewModel: SkillTableViewCellModel?
    private(set) var skillListing: SkillListing?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight

        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        let topView = topViewContainer()
        stack.addArrangedSubview(topView)
        let bottomView = descriptionView(frameAboveHeight: topView.frame.height)
        
        
        /// NEXT: Remove the damn stack and just do this manually
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stack.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stack.heightAnchor.constraint(equalToConstant: SkillTableConstants.rowHeight)
            ])
        
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 0
        
        self.topView = topView
        self.bottomView = bottomView
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
    func prepare(with skillListing: SkillListing, viewModel: SkillTableViewCellModel) {
        self.viewModel = viewModel
        self.skillListing = skillListing
    }
    
    /// Updates the skill listing. This can be called at any time to change the values displayed.
    ///
    /// - Parameter skillListing: The skill listing to display
    func update(skillListing: SkillListing) {
        self.skillListing = skillListing
        updateColumnValues()
    }
    
    func showDescription() {
        guard let bottomView = bottomView,
            let topView = topView else {
            return
        }
//        CONTENT.addArrangedSubview(bottomView)
        contentView.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
            ])
        
        delegate?.cellHeightDidChange(self)
    }
    
    func hideDescription() {
        guard let bottomView = bottomView else {
            return
        }
        
        bottomView.removeFromSuperview()
        delegate?.cellHeightDidChange(self)
    }
    
    private func descriptionView(frameAboveHeight: CGFloat) -> UIView {
        let descriptionHeight = contentView.frame.height * 4 - frameAboveHeight
        let descriptionFrame = CGRect(x: 0.0, y: frameAboveHeight, width: contentView.frame.width, height: descriptionHeight)
        let skillDescription = descriptionBox(frame: descriptionFrame)
        skillDescription.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        skillDescription.translatesAutoresizingMaskIntoConstraints = false
        self.skillDescription = skillDescription
        
        return skillDescription
    }
    
    /// Update the skill listing for the table view.
    private func updateColumnValues() {
        guard let viewModel = viewModel, let skillListing = skillListing else { return }
        
        var name = skillListing.skill.name
        
        if let nameExtension = skillListing.skill.nameExtension {
            name = "\(name): \(nameExtension)"
        }
        
        self.name?.text = name
        self.name?.font = viewModel.nameFont
        self.name?.textAlignment = .left
        self.name?.fitTextToBounds(maximumSize: viewModel.fontSize)
        
        points?.text = "\(skillListing.points)"
        points?.font = viewModel.numberFont
        points?.textAlignment = .center
        points?.fitTextToBounds(maximumSize: viewModel.fontSize)
        
        modifier?.text = "\(skillListing.modifier)"
        modifier?.font = viewModel.numberFont
        modifier?.textAlignment = .center
        modifier?.fitTextToBounds(maximumSize: viewModel.fontSize)
        
        total?.text = "\(skillListing.skillRollValue)"
        total?.font = viewModel.totalFont
        total?.textAlignment = .center
        total?.fitTextToBounds(maximumSize: viewModel.fontSize)
        
        skillDescription?.text = skillListing.skill.description
        skillDescription?.font = StyleConstants.Font.light?.withSize(StyleConstants.Font.minimumSize)
        
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
        let numericCellWidthRatio = CGFloat(0.15) // 3 cells, 15% of width each
        
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
        
        // MARK: Numeric Column Construction
        
        var trailingAnchor = topViewContainer.trailingAnchor
        var count = 0
        
        for numericColumn in 1...3 {
            let numericFrameWidth = totalWidth * numericCellWidthRatio
            let numericFrame = CGRect(x: nameFrameWidth + (numericFrameWidth * CGFloat(count)),
                                      y: safeFrame.minY,
                                      width: numericFrameWidth,
                                      height: safeFrame.height)
            let numericMargins = NSDirectionalEdgeInsets(top: numericFrame.height * 0.05,
                                                         leading: numericFrame.width * 0.05,
                                                         bottom: numericFrame.height * 0.05,
                                                         trailing: numericFrame.width * 0.05)
            let backgroundColor = numericColumn % 2 > 0 ? StyleConstants.Color.gray : StyleConstants.Color.light
            let numericView = UILabel.container(frame: numericFrame,
                                                margins: numericMargins,
                                                backgroundColor: backgroundColor,
                                                borderColor: nil, borderWidth: nil,
                                                labelMaker: columnLabel)
            
            numericView.label.backgroundColor = backgroundColor
            
            // Store the labels on the object to be edited by the update function
            switch numericColumn {
            case 3:
                points = numericView.label
            case 2:
                modifier = numericView.label
            case 1:
                total = numericView.label
            default:
                break
            }
            
            topViewContainer.addSubview(numericView.container)
            
            NSLayoutConstraint.activate([
                numericView.container.trailingAnchor.constraint(equalTo: trailingAnchor),
                numericView.container.topAnchor.constraint(equalTo: topViewContainer.topAnchor),
                numericView.container.widthAnchor.constraint(equalTo: topViewContainer.widthAnchor, multiplier: numericCellWidthRatio),
                numericView.container.heightAnchor.constraint(equalToConstant: SkillTableConstants.rowHeight)
                ])
            
            trailingAnchor = numericView.container.leadingAnchor
            count += 1
        }
        return topViewContainer
    }
    
    private func descriptionBox(frame: CGRect) -> UITextView {
        let textView = UITextView(frame: frame)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateColumnValues()
    }
    
}
