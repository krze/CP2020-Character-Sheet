//
//  ShortTextEntryCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

// This file contains all the single-line entry views. I don't like subclassing,
// and this should be re-worked for composition, but this was a fast MVP build to
// test out the revamped editor.

import UIKit

/// A single-line textfield that accepts user entry without validation
final class ShortTextEntryCollectionViewCell: UICollectionViewCell, ShortFormEntryCollectionViewCell, UsedOnce {
    
    override var tag: Int {
        didSet {
            textField?.tag = tag
        }
    }
    
    // MARK: UsedOnce
    
    var wasSetUp = false
    
    // MARK: ShortFormEntryCollectionViewCell
    
    private(set) var identifier = ""
    private(set) var fieldDescription = ""
    private(set) var textField: UITextField?

    private let viewModel = EditorStyleConstants()
    private var header: UILabel?

    func setup(with identifier: Identifier, value: String, description: String) {
        guard !wasSetUp else {
            self.identifier = identifier
            self.textField?.text = value
            return
        }
        
        self.identifier = identifier
        self.fieldDescription = description
        
        let headerView = CommonViews.headerView(size: .zero, text: identifier)
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
        
        let textField = CommonViews.textField(frame: .zero, placeholder: value)
        
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            textField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -(sidePadding * 2)),
            textField.heightAnchor.constraint(equalToConstant: viewModel.entryHeight)
            ])

        self.textField = textField
        self.contentView.backgroundColor = viewModel.lightColor
        wasSetUp = true
    }

    // MARK: Private

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
        alert.addAction(UIAlertAction(title: AlertViewStrings.dismissButtonTitle, style: .default, handler: nil))
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }
    
}
