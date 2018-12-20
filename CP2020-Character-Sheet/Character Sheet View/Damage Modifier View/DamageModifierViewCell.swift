//
//  DamageModifierViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class DamageModifierViewCell: UICollectionViewCell, DamageModifierControllerDelegate {
    
    private var model: DamageModifierViewModel?
    private var controller: DamageModifierController? // TODO: When this is implemented, make it non-optional
    
    func setup(with viewModel: DamageModifierViewModel) {
        model = viewModel
        
        contentView.layoutMargins = UIEdgeInsets(top: contentView.safeAreaLayoutGuide.layoutFrame.height * viewModel.topPaddingRatio,
                                                 left: contentView.safeAreaLayoutGuide.layoutFrame.width * viewModel.leftPaddingRatio,
                                                 bottom: contentView.safeAreaLayoutGuide.layoutFrame.height * viewModel.bottomPaddingRatio,
                                                 right: contentView.safeAreaLayoutGuide.layoutFrame.width * viewModel.rightPaddingRatio)
        
        let totalWidth = contentView.layoutMarginsGuide.layoutFrame.width
        let stunSaveCellFrame = CGRect(x: contentView.layoutMarginsGuide.layoutFrame.minX, y: contentView.layoutMarginsGuide.layoutFrame.minY, width: totalWidth * viewModel.cellWidthRatio, height: contentView.layoutMarginsGuide.layoutFrame.height * viewModel.cellHeightRatio)
        let stunSaveCell = self.cell(frame: stunSaveCellFrame, labelHeightRatio: viewModel.labelHeightRatio, labelType: .Stun)
        
        contentView.addSubview(stunSaveCell)
        
        NSLayoutConstraint.activate([
            stunSaveCell.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stunSaveCell.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stunSaveCell.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: viewModel.cellWidthRatio, constant: -contentView.layoutMargins.right),
            stunSaveCell.heightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.heightAnchor, multiplier: viewModel.cellHeightRatio)
            ])
        
        let middlePadding = contentView.safeAreaLayoutGuide.layoutFrame.width * viewModel.inbetweenPaddingRatio
        
        let btmCellFrame = CGRect(x: stunSaveCellFrame.width + middlePadding, y: contentView.layoutMarginsGuide.layoutFrame.minY, width: totalWidth * viewModel.cellWidthRatio, height: contentView.layoutMarginsGuide.layoutFrame.height * viewModel.cellHeightRatio)
        let btmCell = self.cell(frame: btmCellFrame, labelHeightRatio: viewModel.labelHeightRatio, labelType: .BTM)
        
        contentView.addSubview(btmCell)
        
        NSLayoutConstraint.activate([
            btmCell.leadingAnchor.constraint(equalTo: stunSaveCell.trailingAnchor, constant: middlePadding * 2),
            btmCell.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            btmCell.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: viewModel.cellWidthRatio, constant: -contentView.layoutMargins.right),
            btmCell.heightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.heightAnchor, multiplier: viewModel.cellHeightRatio)
            ])
        
        let totalDMGCellFrame = CGRect(x: stunSaveCellFrame.width + btmCellFrame.width + (middlePadding * 2), y: contentView.layoutMarginsGuide.layoutFrame.minY, width: totalWidth * viewModel.cellWidthRatio, height: contentView.layoutMarginsGuide.layoutFrame.height * viewModel.cellHeightRatio)
        let totalDMGCell = self.cell(frame: totalDMGCellFrame, labelHeightRatio: viewModel.labelHeightRatio, labelType: .TotalDamage)
        
        contentView.addSubview(totalDMGCell)
        
        NSLayoutConstraint.activate([
            totalDMGCell.leadingAnchor.constraint(equalTo: btmCell.trailingAnchor, constant: middlePadding * 2),
            totalDMGCell.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            totalDMGCell.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: viewModel.cellWidthRatio, constant: -contentView.layoutMargins.right),
            totalDMGCell.heightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.heightAnchor, multiplier: viewModel.cellHeightRatio)
            ])
        

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
    
    private func cell(frame: CGRect, labelHeightRatio: CGFloat, labelType: Label) -> UIView {
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
        
        return cell
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
        case Stun, BTM, TotalDamage
        
        func labelText() -> String {
            switch self {
            case .TotalDamage:
                return "Total DMG"
            case .Stun:
                return "Stun Save"
            default:
                return rawValue
            }
        }
    }
}
