//
//  CheckboxEntryCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class CheckboxEntryCollectionViewCell: UICollectionViewCell, CheckboxCollectionViewCell {
    
    private(set) var checkboxes = [Checkbox]()
    private(set) var identifier = ""
    private(set) var fieldDescription = ""
    private(set) var checkboxConfig: CheckboxConfig?

    // Private
    
    private let viewModel = EditorStyleConstants()
    private var header: UIView?
    private var checkboxView: UIView?
    private var checkboxViewBackground: UIView?
    
    func setup(with identifier: Identifier, checkboxConfig: CheckboxConfig, description: String) {
        self.identifier = identifier
        self.fieldDescription = description
        self.checkboxConfig = checkboxConfig
        
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
        
        header = headerView
        
        let checkboxStack = UIStackView(frame: .zero)
        checkboxStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(checkboxStack)
        
        NSLayoutConstraint.activate([
            checkboxStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            checkboxStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            checkboxStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -(sidePadding * 2)),
            checkboxStack.heightAnchor.constraint(equalToConstant: viewModel.checkboxEntryHeight(checkboxConfig))
            ])
        
        setupCheckboxes(verticalStackView: checkboxStack, config: checkboxConfig)
        
        checkboxView = checkboxStack
        contentView.backgroundColor = viewModel.lightColor
    }
    
    func setCheckboxBackgroundColor(_ color: UIColor) {
        checkboxViewBackground?.backgroundColor = color
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
    
    private func setupCheckboxes(verticalStackView: UIStackView, config: CheckboxConfig) {
        let checkboxRows = config.choices
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fillEqually
        
        checkboxRows.forEach { row in
            var arrangedViews = [UIView]()
            row.forEach { checkbox in
                let frameSize = CGSize(width: contentView.safeAreaLayoutGuide.layoutFrame.width / CGFloat(row.count), height: viewModel.entryHeight)
                let frame = CGRect(origin: .zero, size: frameSize)
                let containerModel = CheckboxContainerModel(frame: frame)
                let thisCheckbox = Checkbox(model: containerModel)
                
                thisCheckbox.label.text = checkbox
                thisCheckbox.label.textAlignment = .center
                
                arrangedViews.append(thisCheckbox.container)
                checkboxes.append(thisCheckbox)
            }
            
            let thisRow = UIStackView(arrangedSubviews: arrangedViews)
            thisRow.axis = .horizontal
            thisRow.alignment = .center
            thisRow.distribution = .fillEqually
            thisRow.spacing = contentView.safeAreaLayoutGuide.layoutFrame.width * StyleConstants.Size.edgePaddingRatio
            verticalStackView.addArrangedSubview(thisRow)
        }
        let backgroundView = UIView(frame: verticalStackView.bounds)
        backgroundView.backgroundColor = StyleConstants.Color.light
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        verticalStackView.insertSubview(backgroundView, at: 0)
        
        checkboxViewBackground = backgroundView
    }
    
    @objc private func presentHelpText() {
        let alert = UIAlertController(title: identifier, message: fieldDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertViewStrings.dismissButtonTitle, style: .default, handler: nil))
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }
    
    override func prepareForReuse() {
        checkboxes = [Checkbox]()
        identifier = ""
        fieldDescription = ""
        checkboxConfig = nil
        checkboxView = nil
        header = nil
    }
    
}
