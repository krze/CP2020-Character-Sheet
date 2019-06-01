//
//  IntegerEntryCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class IntegerEntryCollectionViewCell: UserEntryCollectionViewCell {

    var enteredValue: String? {
        return textField?.text
    }

    private var identifier = ""

    private var textField: UITextField?
    private var header: UILabel?
    private var fieldDescription = ""
    private let viewModel = EditorStyleConstants()

    func setup(with identifier: Identifier, placeholder: String, description: String) {
        self.identifier = identifier
        self.fieldDescription = description

        let headerView = CommonEntryConstructor.headerView(size: .zero, text: identifier)
        let sidePadding = self.contentView.frame.width * viewModel.paddingRatio

        contentView.addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            headerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -(sidePadding * 2)),
            headerView.heightAnchor.constraint(equalToConstant: viewModel.headerHeight)
            ])

        let helpButton = self.helpButton(size: CGSize(width: viewModel.headerHeight, height: viewModel.headerHeight))

        headerView.addSubview(helpButton)

        NSLayoutConstraint.activate([
            helpButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            helpButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            helpButton.widthAnchor.constraint(equalToConstant: viewModel.headerHeight),
            helpButton.heightAnchor.constraint(equalToConstant: viewModel.headerHeight)
            ])

        let textField = CommonEntryConstructor.textField(frame: .zero, placeholder: placeholder)
        textField.keyboardType = .numberPad
        
        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            textField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -(sidePadding * 2)),
            textField.heightAnchor.constraint(equalToConstant: viewModel.entryHeight)
            ])

        self.textField = textField
        self.contentView.backgroundColor = viewModel.lightColor
    }

    private func helpButton(size: CGSize) -> UIButton {
        let button = UIButton(type: .infoDark)
        button.frame.size = size
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(presentHelpText), for: .touchUpInside)
        return button
    }

    @objc private func presentHelpText() {
        let alert = UIAlertController(title: identifier, message: fieldDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: SkillStrings.dismissHelpPopoverButtonText, style: .default, handler: nil))
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }

}
