//
//  StatView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/9/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A view containing a stat and its current value
final class StatView: UIView {
    private let model: StatViewModel
    private let divider = " / "
    private let leftBracket = "[ "
    private let rightBracket = " ]"
    
    
    init(frame: CGRect, viewModel: StatViewModel) {
        model = viewModel
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = model.highlightColor
        
        let statLabelWidth = frame.width * model.statValueRatio
        let nameLabelWidth = frame.width - (statLabelWidth)
    
        let nameLabelFrame = CGRect(x: frame.minX,
                                    y: frame.minY,
                                    width: nameLabelWidth,
                                    height: frame.height)
        let nameLabel = self.nameLabel(frame: nameLabelFrame)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: nameLabelWidth),
            nameLabel.heightAnchor.constraint(equalToConstant: frame.height),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        
        let statLabelFrame = CGRect(x: nameLabelWidth,
                                    y: frame.minY,
                                    width: statLabelWidth,
                                    height: frame.height)
        let statLabel = self.statLabel(frame: statLabelFrame)
        addSubview(statLabel)
        
        NSLayoutConstraint.activate([
            statLabel.widthAnchor.constraint(equalToConstant: statLabelWidth),
            statLabel.heightAnchor.constraint(equalToConstant: frame.height),
            statLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            statLabel.topAnchor.constraint(equalTo: topAnchor)
            ])
    }
    
    
    private func nameLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = model.statNameFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = model.darkColor
        label.textColor = model.lightColor
        label.text = model.stat.abbreviation()
        label.textAlignment = .center
        label.fitTextToBounds()
        
        return label
    }
    
    private func statLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = model.statValueFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = model.lightColor
        label.textColor = model.darkColor
        label.text = {
            var value = ""
            
            if model.stat.hasBaseState() {
                value = "\(model.statCurrentValue ?? model.statValue)\(divider)\(model.statValue)"
            }
            else {
                value = "\(model.statValue)"
            }
            
            return "\(leftBracket)\(value)\(rightBracket)"
        }()
        label.layer.borderColor = model.darkColor.cgColor
        label.layer.borderWidth = model.statValueBorder
        label.textAlignment = .center
        label.fitTextToBounds()
        
        return label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
