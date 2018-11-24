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
    
    // Temporary until cells track their own state
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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = model.lightColor

        // MARK: Wound type label construction
        
        let woundTypeLabel = self.label(for: viewModel.woundType, yPosition: self.safeAreaLayoutGuide.layoutFrame.minY)
        addSubview(woundTypeLabel)
        
        woundTypeLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        woundTypeLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        woundTypeLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        addConstraint(NSLayoutConstraint(item: woundTypeLabel,
                                         attribute: .height,
                                         relatedBy: .lessThanOrEqual,
                                         toItem: safeAreaLayoutGuide,
                                         attribute: .height,
                                         multiplier: model.woundTypeLabelViewRatio,
                                         constant: 0))
        woundTypeLabel.updateConstraints()
        views.append(woundTypeLabel)
        
        // MARK: Damage cell container construction
        
        let damageCellYPosition = woundTypeLabel.frame.height
        let damageCellContainer = self.damageCellContainer(yPosition: damageCellYPosition)

        addSubview(damageCellContainer)
        addConstraint(NSLayoutConstraint(item: damageCellContainer,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: woundTypeLabel,
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

        // MARK: Stun label construction
        
        let stunTypeLabelYPosition = damageCellYPosition + damageCellContainer.frame.height
        let stunTypeLabel = self.label(for: viewModel.stunType, yPosition: stunTypeLabelYPosition)
        addSubview(stunTypeLabel)
        
        addConstraint(NSLayoutConstraint(item: stunTypeLabel,
                                         attribute: .height,
                                         relatedBy: .lessThanOrEqual,
                                         toItem: self,
                                         attribute: .height,
                                         multiplier: model.stunLabelViewRatio,
                                         constant: 0))
        stunTypeLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        stunTypeLabel.topAnchor.constraint(equalTo: damageCellContainer.bottomAnchor).isActive = true
        stunTypeLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        stunTypeLabel.updateConstraints()

        views.append(stunTypeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Produces a UILabel for the supplied WoundType
    ///
    /// - Parameters:
    ///   - woundType: The type of wound to be listed in the label
    ///   - yPosition: The yPosition relative to the entire DamageSectionView
    /// - Returns: UILabel ready to be positioned in the cell
    private func label(for woundType: WoundType, yPosition: CGFloat) -> UILabel {
        let text: String = {
            if woundType == .Mortal, let count = model.mortalCount {
                return "\(woundType.rawValue) -\(count)"
            }
            else {
                return woundType.rawValue
            }
        }()
        let label = self.label(for: text, yPosition: yPosition, viewRatio: model.woundTypeLabelViewRatio)
        
        return label
    }
    
    /// Produces a UILabel for the supplied StunType
    ///
    /// - Parameters:
    ///   - stunType: The type of stun to be listed in the label
    ///   - yPosition: The yPosition relative to the entire DamageSectionView
    /// - Returns: UILabel ready to be positioned in the cell
    private func label(for stunType: StunType, yPosition: CGFloat) -> UILabel {
        let text = "\(stunType.rawValue) -\(model.stunCount)"
        let label = self.label(for: text, yPosition: yPosition, viewRatio: model.stunLabelViewRatio, invertColors: true)
        
        return label
    }
    
    private func label(for text: String, yPosition: CGFloat, viewRatio: CGFloat, invertColors: Bool = false) -> UILabel {
        let frame = CGRect(x: 0, y: yPosition, width: self.frame.width, height: self.frame.height * viewRatio)
        
        let label = UILabel(frame: frame)
        
        if invertColors {
            label.backgroundColor = model.darkColor
            label.textColor = model.lightColor
        }
        else {
            label.backgroundColor = model.lightColor
            label.textColor = model.darkColor
        }
        
        label.font = UIFont(name: "AvenirNext-Bold", size: 18.0)
        label.text = text
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
    
    /// Produces the container that holds the cells for the damage track, filled with the number
    /// of cells specified in the DamageSectionViewModel
    ///
    /// - Parameter yPosition: The yPosition relative to the entire DamageSectionView
    /// - Returns: UIView acting as the damage cell container
    private func damageCellContainer(yPosition: CGFloat) -> UIView {
        let frame = CGRect(x: 0, y: yPosition, width: self.frame.width, height: self.frame.height * model.damageCellViewRatio)

        let view = UIView(frame: frame)
        view.backgroundColor = model.lightColor
        view.accessibilityLabel = "DamageCellContainer"
        view.layoutMargins = UIEdgeInsets(top: model.damageCellVerticalPadding,
                                          left: model.damageCellHorizontalPadding,
                                          bottom: model.damageCellVerticalPadding,
                                          right: model.damageCellHorizontalPadding)
        
        // TODO: Make the tracking of this state contained to the cell itself.
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
            backgroundView.layer.borderWidth = model.damageCellBorderThickness
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
