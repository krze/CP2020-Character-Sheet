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
    let stat: Stat
    var currentValue: String? {
        return valueLabel?.text
    }
    var baseValue: Int
    
    init(frame: CGRect, viewModel: StatViewModel) {
        model = viewModel
        stat = viewModel.stat
        baseValue = viewModel.baseValue
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
    
    func updateValue(newValue: Int, baseValue: Int) {
        guard let valueLabel = valueLabel else { return }
        setTextAndColor(on: valueLabel, hasBaseState: true, currentValue: newValue, baseValue: baseValue)
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
        
        setTextAndColor(on: label, hasBaseState: model.stat.hasBaseState(),
                        currentValue: model.statCurrentValue ?? baseValue, baseValue: baseValue)
        
        return label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTextAndColor(on label: UILabel, hasBaseState: Bool, currentValue: Int, baseValue: Int) {
        let labelValue = hasBaseState ? currentValue : baseValue
        label.text = "\(labelValue)"
        label.textColor = hasBaseState && labelValue < baseValue ? model.badColor : model.darkColor
        label.textAlignment = .center
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
    }
    
}
