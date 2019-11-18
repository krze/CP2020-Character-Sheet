//
//  CheckboxEntryCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class CheckboxEntryCollectionViewCell: UICollectionViewCell, CheckboxCollectionViewCell, UsedOnce {
    
    private(set) var checkboxes = [Checkbox]()
    private(set) var identifier = ""
    private(set) var fieldDescription = ""
    
    private(set) var wasSetUp = false

    private let viewModel = EditorStyleConstants()
    private var header: UILabel?
    private var checkboxCollection: UIView?
    
    func setup(with identifier: Identifier, checkboxConfig: CheckboxConfig, description: String) {
        guard !wasSetUp else { return }
        
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
        
        let checkboxCollection = UIView(frame: .zero)
        checkboxCollection.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(checkboxCollection)
        
        NSLayoutConstraint.activate([
            checkboxCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            checkboxCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            checkboxCollection.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -(sidePadding * 2)),
            checkboxCollection.heightAnchor.constraint(equalToConstant: viewModel.checkboxEntryHeight(checkboxConfig))
            ])
        
        contentView.backgroundColor = viewModel.lightColor
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
