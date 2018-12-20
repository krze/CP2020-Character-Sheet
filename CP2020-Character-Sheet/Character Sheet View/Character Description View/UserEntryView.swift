//
//  UserEntryView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/14/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A simple view containing a static label and a textview for user input
/// Used for things like character name
final class UserEntryView: UIView, UITextFieldDelegate {
    private let viewModel: UserEntryViewModel
    private var inputField: UITextField?
    
    init(frame: CGRect, viewModel: UserEntryViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = viewModel.lightColor
        
        let labelWidth = frame.width * viewModel.labelWidthRatio
        let labelFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width * viewModel.labelWidthRatio, height: frame.height)
        let labelMargins = viewModel.createInsets(with: labelFrame)
        let label = UILabel.container(frame: labelFrame,
                                          margins: labelMargins,
                                          backgroundColor: viewModel.darkColor,
                                          borderColor: nil,
                                          borderWidth: nil,
                                          labelMaker: self.label)
        
        addSubview(label.container)
        NSLayoutConstraint.activate([
            label.container.widthAnchor.constraint(lessThanOrEqualToConstant: labelWidth),
            label.container.heightAnchor.constraint(equalToConstant: frame.height),
            label.container.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.container.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        let inputFieldWidth = frame.width * viewModel.inputWidthRatio
        let inputFieldFrame = CGRect(x: labelFrame.width, y: frame.minY, width: inputFieldWidth, height: frame.height)
        let inputField = self.inputField(frame: inputFieldFrame)
        
        addSubview(inputField)
        NSLayoutConstraint.activate([
            inputField.widthAnchor.constraint(lessThanOrEqualToConstant: inputFieldWidth),
            inputField.heightAnchor.constraint(equalToConstant: frame.height),
            inputField.leadingAnchor.constraint(equalTo: label.container.trailingAnchor),
            inputField.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        self.inputField = inputField
        self.inputField?.delegate = self
    }
    
    private func label(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = viewModel.labelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = viewModel.darkColor
        label.textColor = viewModel.lightColor
        label.text = viewModel.labelText
        label.textAlignment = .center
        label.fitTextToBounds()
        
        return label
    }
    
    private func inputField(frame: CGRect) -> UITextField {
        let field = UITextField(frame: frame)
        field.font = viewModel.inputFont
        field.minimumFontSize = viewModel.inputMinimumSize
        field.adjustsFontSizeToFitWidth = true
        field.autocorrectionType = .no
        field.layer.borderColor = viewModel.darkColor.cgColor
        field.layer.borderWidth = StyleConstants.SizeConstants.borderWidth
        
        return field
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
