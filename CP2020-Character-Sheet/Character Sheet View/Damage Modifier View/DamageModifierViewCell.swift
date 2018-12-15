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
        
        let totalWidth = contentView.layoutMarginsGuide.layoutFrame.width - contentView.layoutMargins.right
        let stunSaveCellFrame = CGRect(x: contentView.layoutMarginsGuide.layoutFrame.minX, y: contentView.layoutMarginsGuide.layoutFrame.minY, width: totalWidth * viewModel.stunSaveCellWidthRatio, height: contentView.layoutMarginsGuide.layoutFrame.height * viewModel.cellHeightRatio)
        let stunSaveCell = self.cell(frame: stunSaveCellFrame, labelHeightRatio: viewModel.stunSaveLabelHeightRatio, labelType: .Stun)
        
        contentView.addSubview(stunSaveCell)
        
        NSLayoutConstraint.activate([
            stunSaveCell.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stunSaveCell.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stunSaveCell.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: viewModel.stunSaveCellWidthRatio, constant: -contentView.layoutMargins.right),
            stunSaveCell.heightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.heightAnchor, multiplier: viewModel.cellHeightRatio)
            ])
        
        let middlePadding = contentView.safeAreaLayoutGuide.layoutFrame.width * viewModel.inbetweenPaddingRatio
        
        let btmCellFrame = CGRect(x: stunSaveCellFrame.width + middlePadding, y: contentView.layoutMarginsGuide.layoutFrame.minY, width: totalWidth * viewModel.bodyTypeModifierCellWidthRatio, height: contentView.layoutMarginsGuide.layoutFrame.height * viewModel.cellHeightRatio)
        let btmCell = self.cell(frame: btmCellFrame, labelHeightRatio: viewModel.bodyTypeModifierLabelHeightRatio, labelType: .BTM)
        
        contentView.addSubview(btmCell)
        
        NSLayoutConstraint.activate([
            btmCell.leadingAnchor.constraint(equalTo: stunSaveCell.trailingAnchor, constant: middlePadding * 2),
            btmCell.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            btmCell.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor, multiplier: viewModel.bodyTypeModifierCellWidthRatio, constant: -contentView.layoutMargins.right),
            btmCell.heightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.heightAnchor, multiplier: viewModel.cellHeightRatio)
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
        let label: UILabel = {
            let labelFrame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height * labelHeightRatio)
            
            if labelType == .Stun {
                return sectionLabel(frame: labelFrame, text: model?.stunSaveText ?? "")
            }
            
            return sectionLabel(frame: labelFrame, text: model?.bodyTypeModifierText ?? "")
        }()
        
        cell.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            label.topAnchor.constraint(equalTo: cell.topAnchor),
            label.widthAnchor.constraint(equalTo: cell.widthAnchor),
            label.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: labelHeightRatio)
            ])
        
        let valueLabelRatio = 1.0 - labelHeightRatio
        let valueLabel = self.valueLabel(frame: CGRect(x: 0.0, y: label.frame.height, width: frame.width, height: frame.height * valueLabelRatio))
        
        cell.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            valueLabel.topAnchor.constraint(equalTo: label.bottomAnchor),
            valueLabel.widthAnchor.constraint(equalTo: cell.widthAnchor),
            valueLabel.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: valueLabelRatio)
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
        label.fitTextToBounds()
        
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
        label.fitTextToBounds()
                
        return label
    }
    
    private enum Label {
        case Stun, BTM
    }
}
