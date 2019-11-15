//
//  DamageModifierViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class DamageModifierViewCell: UICollectionViewCell, DamageModifierDataSourceDelegate, UsedOnce {
    
    private (set) var wasSetUp: Bool = false

    private var model: DamageModifierViewModel?
    private var dataSource: DamageModifierDataSource?
    
    private var cells = [Label: UILabel]()
    
    func setup(with viewModel: DamageModifierViewModel) {
        if wasSetUp {
            dataSource?.refreshData()
            return
        }
        
        model = viewModel
        
        contentView.layoutMargins = UIEdgeInsets(top: contentView.safeAreaLayoutGuide.layoutFrame.height * viewModel.paddingRatio,
                                                 left: contentView.safeAreaLayoutGuide.layoutFrame.width * viewModel.paddingRatio,
                                                 bottom: contentView.safeAreaLayoutGuide.layoutFrame.height * viewModel.paddingRatio,
                                                 right: contentView.safeAreaLayoutGuide.layoutFrame.width * viewModel.paddingRatio)
        
        let damageModifierCellLabels = Label.allCases.map { $0 }
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
            let size = CGSize(width: subviewWidth, height: subviewHeight)
            let frame = CGRect(origin: .zero, size: size)
            
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
    
    func update(dataSource: DamageModifierDataSource) {
        self.dataSource = dataSource
        self.dataSource?.delegate = self
    }
    
    // MARK: DamageModifierDataSourceDelegate
    
    func bodyTypeDidChange(save: Int, btm: Int) {
        let btmCell = cells[.BTM]
        let saveCell = cells[.Save]
        
        btmCell?.text = "\(btm)"
        saveCell?.text = "\(save)"
        btmCell?.fitTextToBounds()
        saveCell?.fitTextToBounds()
    }
     
    func damageDidChange(totalDamage: Int) {
        let damageCell = cells[.TotalDamage]
        
        damageCell?.text = "\(totalDamage)"
        damageCell?.fitTextToBounds()
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
    
    private func sectionLabel(frame: CGRect, text: String) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5

        label.text = text
        label.font = StyleConstants.Font.defaultFont
        label.textColor = StyleConstants.Color.light
        label.backgroundColor = StyleConstants.Color.dark
        label.textAlignment = .center
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return label
    }
    
    private enum Label: String, CaseIterable {
        case Save, BTM, TotalDamage
        
        func labelText() -> String {
            switch self {
            case .TotalDamage:
                return "Total DMG"
            case .Save:
                return "Save"
            default:
                return rawValue
            }
        }
    }
}
