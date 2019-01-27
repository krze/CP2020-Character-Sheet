//
//  TextEntryCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class TextEntryCollectionViewCell: UserEntryCollectionViewCell {
    var enteredValue: String? {
        return textField.text
    }
    
    var identifier = ""
    
    private let textField = UITextField()
    private var header: UILabel?
    private var fieldDescription = ""
    private var placeholder = ""
    private let viewModel = EditorStyleConstants()

    func setup(with identifier: Identifier, placeholder: String, description: String) {
        self.identifier = identifier
        self.placeholder = placeholder
        self.fieldDescription = description
    }
    
    override func layoutSubviews() {
        let headerView = self.headerView(size: CGSize.zero)
        
        contentView.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            headerView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor),
            headerView.heightAnchor.constraint(equalToConstant: viewModel.headerHeight)
            ])
        
        let textField = self.textField(frame: CGRect.zero)
        
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            textField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor),
            textField.heightAnchor.constraint(equalToConstant: viewModel.entryHeight)
            ])
    }
    
    private func headerView(size: CGSize, fullHeight: Bool = false) -> UIView {
        let labelViewFrame = CGRect(x: 0,
                                    y: 0,
                                    width: size.width,
                                    height: size.height)
        let labelViewMargins = viewModel.createInsets(with: labelViewFrame, fullHeight: fullHeight)
        let labelView = UILabel.container(frame: labelViewFrame, margins: labelViewMargins, backgroundColor: viewModel.lightColor, borderColor: nil, borderWidth: nil, labelMaker: headerLabel)
        
        return labelView.container
    }
    
    private func headerLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = viewModel.labelFont
        label.backgroundColor = viewModel.lightColor
        label.textColor = viewModel.darkColor
        label.text = "\(identifier):"
        label.textAlignment = .left
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        header = label
        return label
    }
    
    private func textField(frame: CGRect) -> UITextField {
        let field = UITextField(frame: frame)
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = viewModel.inputFont
        field.backgroundColor = viewModel.lightColor
        field.textColor = viewModel.darkColor
        field.textAlignment = .left
        field.leftView = UIView(frame: CGRect(x: frame.minX, y: frame.minY, width: frame.width * viewModel.paddingRatio, height: frame.height))
        field.text = placeholder
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .done
        field.keyboardAppearance = .dark
        
        return field
    }
}
