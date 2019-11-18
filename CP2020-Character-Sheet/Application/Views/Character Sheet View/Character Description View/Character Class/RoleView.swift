//
//  RoleView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/15/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class RoleView: UIView {
    private let viewModel: RoleViewModel
    private (set) var classLabel: UILabel?
    
    init(frame: CGRect, viewModel: RoleViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        let classLabelWidth = frame.width * viewModel.classLabelWidthRatio
        let classLabelFrame = CGRect(x: frame.minX, y: frame.minY, width: classLabelWidth, height: frame.height)
        let classLabel = UILabel.container(frame: classLabelFrame,
                                           margins: viewModel.createInsets(with: classLabelFrame),
                                           backgroundColor: viewModel.darkColor,
                                           borderColor: nil,
                                           borderWidth: nil,
                                           labelMaker: self.classLabel)
        addSubview(classLabel.container)
        NSLayoutConstraint.activate([
            classLabel.container.widthAnchor.constraint(equalToConstant: classLabelWidth),
            classLabel.container.heightAnchor.constraint(equalToConstant: frame.height),
            classLabel.container.leadingAnchor.constraint(equalTo: leadingAnchor),
            classLabel.container.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        let classDescriptionWidth = frame.width * viewModel.classDescriptionWidthRatio
        let classDescriptionFrame = CGRect(x: classLabelFrame.width, y: frame.minY, width: classDescriptionWidth, height: frame.height)
        let classDescriptionLabel = UILabel.container(frame: classDescriptionFrame,
                                                      margins: viewModel.createInsets(with: classDescriptionFrame),
                                                      backgroundColor: viewModel.lightColor,
                                                      borderColor: viewModel.darkColor,
                                                      borderWidth: StyleConstants.SizeConstants.borderWidth,
                                                      labelMaker: self.classDescriptionLabel)
        
        addSubview(classDescriptionLabel.container)
        
        NSLayoutConstraint.activate([
            classDescriptionLabel.container.widthAnchor.constraint(equalToConstant: classDescriptionWidth),
            classDescriptionLabel.container.heightAnchor.constraint(equalToConstant: frame.height),
            classDescriptionLabel.container.leadingAnchor.constraint(equalTo: classLabel.container.trailingAnchor),
            classDescriptionLabel.container.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        self.classLabel = classDescriptionLabel.label
    }
    
    private func classLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = viewModel.classLabelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = viewModel.darkColor
        label.textColor = viewModel.lightColor
        label.text = viewModel.classLabel.rawValue
        label.textAlignment = .center
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return label
    }
    
    private func classDescriptionLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = viewModel.classDescriptionFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = viewModel.lightColor
        label.textColor = viewModel.darkColor
        label.text = viewModel.roleType?.rawValue ?? ""
        label.textAlignment = .left
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return label
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
