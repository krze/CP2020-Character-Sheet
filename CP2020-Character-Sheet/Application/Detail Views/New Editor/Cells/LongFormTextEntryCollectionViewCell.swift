//
//  LongFormTextEntryCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class LongFormTextEntryCollectionViewCell: UserEntryCollectionViewCell, UITextViewDelegate {
    weak var delegate: UserEntryDelegate?
    
    var enteredValue: String? {
        return textView?.text
    }
    
    private(set) var identifier = ""
    private var header: UILabel?
    private var fieldDescription = ""
    
    let entryIsValid = true
    private let viewModel = EditorStyleConstants()
    private var textView: UITextView?
    
    private var resigning = false
    
    func setup(with identifier: Identifier, placeholder: String, description: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(saveWasCalled), name: .saveWasCalled, object: nil)
        
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
        
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = viewModel.inputFont
        textView.textColor = viewModel.darkColor
        textView.backgroundColor = viewModel.lightColor
        
        contentView.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding / 2),
            textView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -(sidePadding * 2)),
            textView.heightAnchor.constraint(equalToConstant: viewModel.longFormEntryHeight)
            ])
        
        textView.delegate = self
        self.textView = textView
        self.textView?.text = placeholder
        
        if placeholder.count > 0 {
            textView.isEditable = false
        }
        self.contentView.backgroundColor = viewModel.lightColor
    }
    
    func makeFirstResponder() {
        textView?.becomeFirstResponder()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textViewDidEndEditing(_ textField: UITextView) {
        delegate?.entryDidFinishEditing(identifier: identifier, value: enteredValue)
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
        alert.addAction(UIAlertAction(title: SkillStrings.dismissHelpPopoverButtonText, style: .default, handler: nil))
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }
    
    @objc func saveWasCalled() {
        if textView?.isFirstResponder == true {
            textView?.resignFirstResponder()
        }
    }
    
}
