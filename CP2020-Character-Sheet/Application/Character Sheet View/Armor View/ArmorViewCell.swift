//
//  ArmorViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by iKreb Retina on 11/10/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class ArmorViewCell: UICollectionViewCell, ArmorDataSourceDelegate, UsedOnce {
    private(set) var wasSetUp: Bool = false
    private var model: ArmorViewModel?
    private var dataSource: ArmorDataSource?

    private var cells = [BodyLocation: UILabel]()

    func setup(with viewModel: ArmorViewModel) {
        if wasSetUp {
            dataSource?.refreshData()
            return
        }

        model = viewModel

        contentView.layoutMargins = UIEdgeInsets(top: contentView.safeAreaLayoutGuide.layoutFrame.height * viewModel.paddingRatio,
                                                 left: contentView.safeAreaLayoutGuide.layoutFrame.width * viewModel.paddingRatio,
                                                 bottom: contentView.safeAreaLayoutGuide.layoutFrame.height * viewModel.paddingRatio,
                                                 right: contentView.safeAreaLayoutGuide.layoutFrame.width * viewModel.paddingRatio)

        let damageModifierCellLabels = BodyLocation.allCases.map { $0 }
        let subviewTotalWidth = contentView.layoutMarginsGuide.layoutFrame.width
        let paddingWidth = viewModel.paddingRatio * subviewTotalWidth
        let subviewWidth: CGFloat = {
            let presetWidth = subviewTotalWidth * viewModel.cellWidthRatio

            let totalInbetweenSpacingWidth = CGFloat(damageModifierCellLabels.count - 1) * paddingWidth
            let availableWidth = subviewTotalWidth - totalInbetweenSpacingWidth
            let calculatedWidth = availableWidth / CGFloat(damageModifierCellLabels.count)

            return calculatedWidth > presetWidth ? calculatedWidth : presetWidth
        }()
        let subviewHeight = contentView.layoutMarginsGuide.layoutFrame.height * viewModel.cellHeightRatio
        var leadingAnchor = contentView.layoutMarginsGuide.leadingAnchor

        damageModifierCellLabels.enumerated().forEach { index, label in
            let x = contentView.layoutMarginsGuide.layoutFrame.minX + (subviewWidth * CGFloat(index)) + (paddingWidth * CGFloat(index))
            let frame = CGRect(x: x, y: contentView.layoutMarginsGuide.layoutFrame.minY,
                               width: subviewWidth, height: subviewHeight)

            let view = CommonEntryConstructor.simpleHeaderValueCell(frame: frame, labelHeightRatio: viewModel.labelHeightRatio, headerText: label.labelText())
            view.valueLabel.text = viewModel.placeholderValue
            let cell = view.wholeView
            cells[label] = view.valueLabel

            contentView.addSubview(cell)

            let constantPadding = index > 0 ? paddingWidth : 0

            NSLayoutConstraint.activate([
                cell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constantPadding),
                cell.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                cell.widthAnchor.constraint(equalToConstant: frame.width),
                cell.heightAnchor.constraint(equalToConstant: frame.height)
                ])

            leadingAnchor = cell.trailingAnchor
       }

        wasSetUp = true
    }

    func armorDidChange(_ armor: [Armor]) {}
}
