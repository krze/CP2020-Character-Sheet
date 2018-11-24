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
        
        // TODO: Make these injectable via an initializer. This is just debug for now
        let rows = 2
        var startingDamageCellNumber = 1
        let totalDamage = 40
        var wounds = WoundType.allCases.reversed().map { $0 }
        var woundType = wounds.popLast()! // Debug. do not force unwrap.
        let cellCount = 4
        let typeRatio = 0.3
        let cellRatio = 0.3
        let cellHorizontalPaddingSpace = 0.2
        let cellVerticalPaddingSpace = 0.1
        let cellBorderThickness = 1.0
        let stunRatio = 0.4
        let darkColor = UIColor.black
        let lightColor = UIColor.white
        let sectionWidthMultiplier = CGFloat(1.0 / ((CGFloat(totalDamage) / CGFloat(cellCount)) / CGFloat(rows)))
        let sectionHeightMultiplier = CGFloat(1.0 / CGFloat(rows))
        
        // The first cell will start with the top left corner, so leading/top will be the edge
        // of the view. These values will be replaced with the trailing anchor of the cell when
        // the construction is finished
        var leadingAnchor = self.contentView.safeAreaLayoutGuide.leadingAnchor
        var topAnchor = self.contentView.safeAreaLayoutGuide.topAnchor
        
        var nextViewNumber = 1
        var currentRow = 1
        let viewsPerRow = (totalDamage / cellCount) / rows
        var frame = CGRect(x: contentView.safeAreaLayoutGuide.layoutFrame.minX, y: contentView.safeAreaLayoutGuide.layoutFrame.minY, width: contentView.safeAreaLayoutGuide.layoutFrame.width * sectionWidthMultiplier, height: contentView.safeAreaLayoutGuide.layoutFrame.height * sectionHeightMultiplier)
        while startingDamageCellNumber < totalDamage {
            let damageSectionViewModel = DamageSectionViewModel(startingDamageCellNumber: startingDamageCellNumber,
                                                                totalDamage: totalDamage,
                                                                woundType: woundType,
                                                                typeRatio: typeRatio,
                                                                cellRatio: cellRatio,
                                                                cellHorizontalPaddingSpace: cellHorizontalPaddingSpace,
                                                                cellVerticalPaddingSpace: cellVerticalPaddingSpace,
                                                                cellBorderThickness: cellBorderThickness,
                                                                cellCount: cellCount,
                                                                stunRatio: stunRatio,
                                                                darkColor: darkColor,
                                                                lightColor: lightColor)
            let view = DamageSectionView(with: damageSectionViewModel, frame: frame)
            self.contentView.addSubview(view)
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.widthAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: sectionWidthMultiplier),
                view.widthAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: sectionHeightMultiplier)
                ])
            
            // Prep for the next view's relevant properties
            startingDamageCellNumber += cellCount
            nextViewNumber += 1
            
            // Set the next anchors
            leadingAnchor = view.trailingAnchor
            var newRowX: CGFloat?
            var newRowY: CGFloat?
            // Only update the topAnchor if we've gone down a row
            if nextViewNumber > viewsPerRow * currentRow {
                newRowX = contentView.safeAreaLayoutGuide.layoutFrame.minX
                newRowY = contentView.safeAreaLayoutGuide.layoutFrame.minY + (frame.height * CGFloat(currentRow))
                currentRow += 1
                leadingAnchor = contentView.safeAreaLayoutGuide.leadingAnchor
                topAnchor = view.bottomAnchor
            }
            else {
                leadingAnchor = view.trailingAnchor
            }
            
            frame = CGRect(x: newRowX ?? frame.minX + frame.width, y: newRowY ?? frame.minY, width: frame.width, height: frame.height)
            // The last wound type should be mortal, and will continue to be so until all views are constructed.
            // Only update the type if there's another wound type in the list.
            if let nextWoundType = wounds.popLast() {
                woundType = nextWoundType
            }
            
        }
        // Debug

        
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
}
