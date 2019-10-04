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
            let x = contentView.layoutMarginsGuide.layoutFrame.minX + (subviewWidth * CGFloat(index)) + (paddingWidth * CGFloat(index))
            let frame = CGRect(x: x, y: contentView.layoutMarginsGuide.layoutFrame.minY,
                               width: subviewWidth, height: subviewHeight)
            
            let view = self.cell(frame: frame, labelHeightRatio: viewModel.labelHeightRatio, labelType: label)
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
    
    private func cell(frame: CGRect, labelHeightRatio: CGFloat, labelType: Label) -> (wholeView: UIView, valueLabel: UILabel) {
        let cell = UIView(frame: frame)
        cell.translatesAutoresizingMaskIntoConstraints = false
        let containerFrame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height * labelHeightRatio)
        let insets = NSDirectionalEdgeInsets(top: frame.height * StyleConstants.SizeConstants.textPaddingRatio,
                                             leading: frame.width * StyleConstants.SizeConstants.textPaddingRatio,
                                             bottom: frame.height * StyleConstants.SizeConstants.textPaddingRatio,
                                             trailing: frame.width * StyleConstants.SizeConstants.textPaddingRatio)
        // Quick function to make this work better with the label container
        func makeLabel(frame: CGRect) -> UILabel {
            return sectionLabel(frame: frame, text: labelType.labelText())
        }
        
        let labelContainer = UILabel.container(frame: containerFrame,
                                               margins: insets,
                                               backgroundColor: StyleConstants.Color.dark,
                                               borderColor: nil,
                                               borderWidth: nil,
                                               labelMaker: makeLabel)
        
        cell.addSubview(labelContainer.container)
        
        NSLayoutConstraint.activate([
            labelContainer.container.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            labelContainer.container.topAnchor.constraint(equalTo: cell.topAnchor),
            labelContainer.container.widthAnchor.constraint(equalToConstant: containerFrame.width),
            labelContainer.container.heightAnchor.constraint(equalToConstant: containerFrame.height)
            ])
        
                
        let valueLabelRatio = 1.0 - labelHeightRatio
        let valueLabelFrame = CGRect(x: 0.0, y: labelContainer.container.frame.height,
                                     width: frame.width, height: frame.height * valueLabelRatio)
        let valueLabel = self.valueLabel(frame: valueLabelFrame)
        
        cell.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            valueLabel.topAnchor.constraint(equalTo: labelContainer.container.bottomAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: valueLabelFrame.width),
            valueLabel.heightAnchor.constraint(equalToConstant: valueLabelFrame.height)
            ])
        
        return (cell, valueLabel)
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
    
    private func valueLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5

        label.text = model?.placeholderValue
        label.font = StyleConstants.Font.defaultBold
        label.textColor = StyleConstants.Color.dark
        label.backgroundColor = StyleConstants.Color.light
        label.layer.borderColor = StyleConstants.Color.dark.cgColor
        label.layer.borderWidth = StyleConstants.SizeConstants.borderWidth
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
