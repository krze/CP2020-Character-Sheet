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
    
    /// Sets up the cell with the given ArmorViewModel
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
        let subviewWidth: CGFloat = subviewTotalWidth * viewModel.cellWidthRatio
        let subviewHeight = contentView.layoutMarginsGuide.layoutFrame.height * viewModel.cellHeightRatio
        var leadingAnchor = contentView.layoutMarginsGuide.leadingAnchor

        damageModifierCellLabels.enumerated().forEach { index, label in
            let size = CGSize(width: subviewWidth, height: subviewHeight)
            let frame = CGRect(origin: .zero, size: size)

            let view = CommonEntryConstructor.simpleHeaderValueCell(frame: frame, labelHeightRatio: viewModel.labelHeightRatio, headerText: label.labelText())
            view.valueLabel.text = viewModel.placeholderValue
            let cell = view.wholeView
            cells[label] = view.valueLabel

            contentView.addSubview(cell)

            NSLayoutConstraint.activate([
                cell.leadingAnchor.constraint(equalTo: leadingAnchor),
                cell.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                cell.widthAnchor.constraint(equalToConstant: frame.width),
                cell.heightAnchor.constraint(equalToConstant: frame.height)
                ])

            leadingAnchor = cell.trailingAnchor
            view.valueLabel.fitTextToBounds()
       }
        
        backgroundColor = StyleConstants.Color.light
        setupTapTarget()
        wasSetUp = true
    }

    func armorDidChange(locationSPS: [BodyLocation: Int]) {
        locationSPS.forEach { location, sps in
            let cell = cells[location]
            cell?.text = String(sps)
            cell?.fitTextToBounds()
        }
    }
    
    /// Updates the view cell with the ArmorDataSource
    /// - Parameter dataSource: The ArmorDataSource
    func update(dataSource: ArmorDataSource) {
        dataSource.delegate = self
        self.dataSource = dataSource
        self.dataSource?.refreshData()
    }
    
    @objc private func cellTapped() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let viewHeader = AnatomyDisplayView()
            let headerViewController = AnatomyDisplayController(viewHeader)
            let viewModel = StatusTableViewModel(title: "Armor Status",
                                                 viewHeaderHeight: AnatomyDisplayView.Constants.heightAsStatusHeaderView,
                                                 viewHeader: viewHeader,
                                                 dataSource: self.dataSource,
                                                 navigationBarEdtingClosure: self.dataSource?.createAddArmorButton)
            let statusTableView = StatusTableView(with: viewModel, headerViewController: headerViewController)
            
            self.dataSource?.anatomyDisplayController = headerViewController
            NotificationCenter.default.post(name: .showEditor, object: statusTableView)
        }
    }
    
    private func setupTapTarget() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        tap.cancelsTouchesInView = false
        tap.numberOfTouchesRequired = 1
        contentView.addGestureRecognizer(tap)
    }
}
