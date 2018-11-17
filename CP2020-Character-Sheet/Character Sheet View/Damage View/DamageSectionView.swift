//
//  DamageSectionView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A single unit of damage cells (default 4) representing one section of the damage track from the CP2020 character sheet.
final class DamageSectionView: UIView {
    
    private let model: DamageSectionViewModel
    private var damageCells = [UIView]()
    private var views = [UIView]()
    
    /// Create a damage section containing 4 damage points
    ///
    /// - Parameters:
    ///   - viewModel: The DamageSectionViewModel containing the model info necessary to construct the frame
    ///   - frame: CGRect for the entire damage section
    init(with viewModel: DamageSectionViewModel, frame: CGRect) {
        model = viewModel
        super.init(frame: frame)
        backgroundColor = model.lightColor

        let damageTypeLabel = self.damageTypeLabel(yPosition: frame.origin.y)
        addSubview(damageTypeLabel)
        
        damageTypeLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        damageTypeLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        damageTypeLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        addConstraint(NSLayoutConstraint(item: damageTypeLabel,
                                         attribute: .height,
                                         relatedBy: .lessThanOrEqual,
                                         toItem: safeAreaLayoutGuide,
                                         attribute: .height,
                                         multiplier: model.damageTypeLabelViewRatio,
                                         constant: 0))
        damageTypeLabel.updateConstraints()
        views.append(damageTypeLabel)
        
        let damageCellContainer = self.damageCellContainer(yPosition: damageTypeLabel.frame.height)

        addSubview(damageCellContainer)
        addConstraint(NSLayoutConstraint(item: damageCellContainer,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: damageTypeLabel,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: damageCellContainer,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: safeAreaLayoutGuide,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: damageCellContainer,
                                         attribute: .height,
                                         relatedBy: .lessThanOrEqual,
                                         toItem: self,
                                         attribute: .height,
                                         multiplier: model.damageCellViewRatio,
                                         constant: 0))
        damageCellContainer.updateConstraints()

        views.append(damageCellContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func damageTypeLabel(yPosition: CGFloat) -> UILabel {
        let frame = CGRect(x: 0, y: yPosition, width: self.frame.width, height: self.frame.height * model.damageTypeLabelViewRatio)
        let label = UILabel(frame: frame)
        
        label.text = model.woundType.rawValue
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
    
    private func damageCellContainer(yPosition: CGFloat) -> UIView {
        let frame = CGRect(x: 0, y: yPosition, width: self.frame.width, height: self.frame.height * model.damageCellViewRatio)

        let view = UIView(frame: frame)
        view.backgroundColor = model.lightColor
        view.accessibilityLabel = "DamageCellContainer"
        view.layoutMargins = UIEdgeInsets(top: model.damageCellVerticalPadding,
                                          left: model.damageCellHorizontalPadding,
                                          bottom: model.damageCellVerticalPadding,
                                          right: model.damageCellHorizontalPadding)
        
        let damageCells = self.damageCells(frame: view.frame, count: model.damageCellCount)
        
        let cellWidth = calculateWidth(forFrameCount: damageCells.count, toFit: view.frame)
        let cellHeight = view.frame.height - model.damageCellVerticalPadding
        
        damageCells.enumerated().forEach { index, cell in
            cell.accessibilityLabel = "Cell \(index)"
            view.addSubview(cell)
            
            cell.translatesAutoresizingMaskIntoConstraints = false

            var constraints = [
                NSLayoutConstraint(item: cell, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: CGFloat(1.0), constant: cellWidth),
                NSLayoutConstraint(item: cell, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: CGFloat(1.0), constant: cellHeight),
            ]
            
            if index == 0 {
                constraints.append(
                    NSLayoutConstraint(item: cell, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leadingMargin, multiplier: 1.0, constant: 0)
                )
            }
            else {
                constraints.append(
                    NSLayoutConstraint(item: cell, attribute: .leading, relatedBy: .equal, toItem: damageCells[index - 1], attribute: .trailing, multiplier: 1.0, constant: model.damageCellHorizontalPadding)
                )
                
            }
            
            constraints.append(NSLayoutConstraint(item: cell, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0))
            
            
            NSLayoutConstraint.activate(constraints)
        }
        
        return view
    }
    
    // TODO: Break these into their own type to make state preservation easier.
    private func damageCells(frame: CGRect, count: Int) -> [UIView] {
        var views = [UIView]()
        let cellWidth = calculateWidth(forFrameCount: count, toFit: frame)
        let cellHeight = frame.height - model.damageCellVerticalPadding
        
        for _ in 1...count {
            let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight))
            backgroundView.backgroundColor = model.lightColor
            backgroundView.layer.borderWidth = 2
            backgroundView.layer.borderColor = model.darkColor.cgColor
            
            views.append(backgroundView)
        }
        
        
        return views
    }
    
    private func calculateWidth(forFrameCount count: Int, toFit rect: CGRect) -> CGFloat {
        let targetWidth = rect.width
        let widthMinusPadding = (targetWidth / CGFloat(count)) - model.damageCellHorizontalPadding
        
        return widthMinusPadding
    }
}
