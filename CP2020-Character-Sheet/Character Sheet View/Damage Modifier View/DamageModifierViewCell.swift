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
        translatesAutoresizingMaskIntoConstraints = false
        
        let stunSaveCellFrame = CGRect(x: 0.0, y: 0.0, width: frame.width * (model?.stunSaveCellWidthRatio ?? 0), height: frame.height * (model?.stunSaveLabelHeightRatio ?? 0))
        let stunSaveCell = self.stunSaveCell(frame: stunSaveCellFrame)
        
        contentView.addSubview(stunSaveCell)
        
        NSLayoutConstraint.activate([
            stunSaveCell.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stunSaveCell.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
            ])
    }
    
    init(frame: CGRect, viewModel: DamageModifierViewModel) {
        model = viewModel
        super.init(frame: frame)

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
    
    private func stunSaveCell(frame: CGRect) -> UIView {
        let cell = UIView(frame: frame)
        let label = stunSaveLabel(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height * (model?.stunSaveLabelHeightRatio ?? 0)))
        cell.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            label.topAnchor.constraint(equalTo: cell.topAnchor),
            label.widthAnchor.constraint(equalTo: cell.widthAnchor),
            label.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: (model?.stunSaveLabelHeightRatio ?? 0))
            ])
        
        let valueLabelRatio = 1.0 - (model?.stunSaveLabelHeightRatio ?? 0)
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
    
    private func stunSaveLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = model?.stunSaveText
        label.font = StyleConstants.Font.defaultFont
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
    
    private func btmLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = model?.bodyTypeModifierText
        label.font = StyleConstants.Font.defaultFont
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
    
    private func valueLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = model?.placeholderValue
        label.font = StyleConstants.Font.defaultBold
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
}
