//
//  DamageViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class DamageViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Debug
        let damageSectionViewModel = DamageSectionViewModel(startingDamageCellNumber: 1,
                                                            totalDamage: 40,
                                                            woundType: .Light,
                                                            typeRatio: 0.3,
                                                            cellRatio: 0.4,
                                                            cellHorizontalPaddingSpace: 0.2,
                                                            cellVerticalPaddingSpace: 0.1,
                                                            cellCount: 4,
                                                            stunRatio: 0.3,
                                                            darkColor: .black,
                                                            lightColor: .white)
        
        let testView = DamageSectionView(with: damageSectionViewModel, frame: frame)
        self.contentView.addSubview(testView)
        NSLayoutConstraint.activate([
            testView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            testView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            testView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            ])
        
        self.contentView.backgroundColor = .lightGray
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
