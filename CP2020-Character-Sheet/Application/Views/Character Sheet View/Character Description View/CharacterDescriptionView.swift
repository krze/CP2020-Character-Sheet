//
//  CharacterDescriptionView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/14/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A simple view containing a static label and a label controlled by user data.
final class CharacterDescriptionView: UIView {
    private let viewModel: CharacterDescriptionViewModel
    
    private(set) var fieldDescription: RoleFieldLabel
    private(set) var inputField: UILabel?
    
    init(frame: CGRect, viewModel: CharacterDescriptionViewModel) {
        self.fieldDescription = viewModel.labelText
        self.viewModel = viewModel
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = viewModel.lightColor
        
        let labelWidth = frame.width * viewModel.labelWidthRatio
        let labelFrame = CGRect(x: frame.minX, y: frame.minY, width: labelWidth, height: frame.height)
        let labelMargins = viewModel.createInsets(with: labelFrame)
        let label = UILabel.container(frame: labelFrame,
                                          margins: labelMargins,
                                          backgroundColor: viewModel.darkColor,
                                          borderColor: nil,
                                          borderWidth: nil,
                                          labelMaker: self.label)
        
        addSubview(label.container)
        NSLayoutConstraint.activate([
            label.container.widthAnchor.constraint(equalToConstant: labelWidth),
            label.container.heightAnchor.constraint(equalToConstant: frame.height),
            label.container.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.container.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        let inputFieldWidth = frame.width * viewModel.inputWidthRatio
        let inputFieldFrame = CGRect(x: labelFrame.width, y: frame.minY, width: inputFieldWidth, height: frame.height)
        let inputField = UILabel.container(frame: inputFieldFrame,
                                           margins: viewModel.createInsets(with: inputFieldFrame),
                                           backgroundColor: viewModel.lightColor,
                                           borderColor: viewModel.darkColor,
                                           borderWidth: StyleConstants.Size.borderWidth,
                                           labelMaker: self.inputField)
        
        addSubview(inputField.container)
        NSLayoutConstraint.activate([
            inputField.container.widthAnchor.constraint(equalToConstant: inputFieldWidth),
            inputField.container.heightAnchor.constraint(equalToConstant: frame.height),
            inputField.container.leadingAnchor.constraint(equalTo: label.container.trailingAnchor),
            inputField.container.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        self.inputField = inputField.label
    }
    
    private func label(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = viewModel.labelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = viewModel.darkColor
        label.textColor = viewModel.lightColor
        label.text = viewModel.labelText.rawValue
        label.textAlignment = .center
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return label
    }
    
    private func inputField(frame: CGRect) -> UILabel {
        let field = UILabel(frame: frame)
        field.translatesAutoresizingMaskIntoConstraints = false

        field.font = viewModel.inputFont
        field.adjustsFontSizeToFitWidth = false
        field.backgroundColor = viewModel.lightColor
        field.textColor = viewModel.darkColor
        field.textAlignment = .left
        
        return field
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
