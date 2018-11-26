//
//  DamageModifierViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class DamageModifierViewCell: UICollectionViewCell {
    
    private let model: DamageModifierViewModel
    
    func setup(with viewModel: DamageModifierViewModel) {
        
    }
    
    init(frame: CGRect, viewModel: DamageModifierViewModel) {
        super.init(frame: frame)
        model = viewModel
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
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
        let label = stunSaveLabel(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height * model.stunSaveLabelHeightRatio))
        cell.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            label.topAnchor.constraint(equalTo: cell.topAnchor),
            label.widthAnchor.constraint(equalTo: cell.widthAnchor),
            label.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: model.stunSaveLabelHeightRatio)
            ])
        
        // NEXT: Label to contain the actual stun save value
        return cell
    }
    
    private func stunSaveLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = model.stunSaveText
        label.font = StyleConstants.defaultFont
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
    
    private func btmLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = model.bodyTypeModifierText
        label.font = StyleConstants.defaultFont
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
}
