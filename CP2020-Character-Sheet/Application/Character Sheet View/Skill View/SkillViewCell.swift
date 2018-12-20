//
//  SkillViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class SkillViewCell: UICollectionViewCell {
    private var viewModel: SkillViewCellModel?
    
    func setup(viewModel: SkillViewCellModel) {
        self.viewModel = viewModel
        let safeFrame = contentView.safeAreaLayoutGuide.layoutFrame
        let cellDescriptionLabelFrame = CGRect(x: safeFrame.minX, y: safeFrame.minY,
                                               width: safeFrame.width * viewModel.cellDescriptionLabelWidthRatio,
                                               height: safeFrame.height * viewModel.cellDescriptionLabelHeightRatio)
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
        let highlightedTableContainerFrame = CGRect(x: safeFrame.minX,
                                                    y: safeFrame.minY + cellDescriptionLabelFrame.height,
                                                    width: safeFrame.width,
                                                    height: safeFrame.height - cellDescriptionLabelFrame.height)
        let highlightedTableContainer = UIView(frame: highlightedTableContainerFrame)
        
        // debug
        highlightedTableContainer.backgroundColor = StyleConstants.Color.red
        
        highlightedTableContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(highlightedTableContainer)
        
        NSLayoutConstraint.activate([
            highlightedTableContainer.topAnchor.constraint(equalTo: cellDescriptionLabel.container.bottomAnchor),
            highlightedTableContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            highlightedTableContainer.widthAnchor.constraint(equalToConstant: highlightedTableContainer.frame.width),
            highlightedTableContainer.heightAnchor.constraint(equalToConstant: highlightedTableContainer.frame.height)
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
    
}
