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
    
    private var statNameLabel: UILabel?
    private var valueLabel: UILabel?
    
    init(frame: CGRect, viewModel: StatViewModel) {
        model = viewModel
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = model.lightColor
        
        let statLabelWidth = frame.width * model.statValueRatio
        let nameLabelWidth = frame.width - (statLabelWidth)
    
        let nameLabelFrame = CGRect(x: frame.minX,
                                    y: frame.minY,
                                    width: nameLabelWidth,
                                    height: frame.height)
        let nameLabelInsets = viewModel.createInsets(with: nameLabelFrame)
        let nameLabel = UILabel.container(frame: nameLabelFrame,
                                          margins: nameLabelInsets,
                                          backgroundColor: model.darkColor,
                                          borderColor: nil,
                                          borderWidth: nil,
                                          labelMaker: self.nameLabel)
        
        addSubview(nameLabel.container)
        NSLayoutConstraint.activate([
            nameLabel.container.widthAnchor.constraint(equalToConstant: nameLabelWidth),
            nameLabel.container.heightAnchor.constraint(equalToConstant: frame.height),
            nameLabel.container.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.container.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        let statLabelFrame = CGRect(x: nameLabelWidth,
                                    y: frame.minY,
                                    width: statLabelWidth,
                                    height: frame.height)
        let statLabelInsets = viewModel.createInsets(with: statLabelFrame)
        let statLabel = UILabel.container(frame: statLabelFrame,
                                          margins: statLabelInsets,
                                          backgroundColor: model.lightColor,
                                          borderColor: model.darkColor,
                                          borderWidth: model.statValueBorder,
                                          labelMaker: self.statLabel)
        
        addSubview(statLabel.container)
        NSLayoutConstraint.activate([
            statLabel.container.widthAnchor.constraint(equalToConstant: statLabelWidth),
            statLabel.container.heightAnchor.constraint(equalToConstant: frame.height),
            statLabel.container.leadingAnchor.constraint(equalTo: nameLabel.container.trailingAnchor),
            statLabel.container.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        statNameLabel = statLabel.label
        valueLabel = statLabel.label
    }
    
    private func nameLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = model.statNameFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = model.darkColor
        label.textColor = model.lightColor
        label.text = model.stat.abbreviation()
        label.textAlignment = .center
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
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
            
            return value
        }()
        label.textAlignment = .center
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
