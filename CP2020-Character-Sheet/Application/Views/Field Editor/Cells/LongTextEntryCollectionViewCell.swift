//
//  LongTextEntryCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class LongTextEntryCollectionViewCell: UICollectionViewCell, LongFormEntryCollectionViewCell, UsedOnce {
        
    override var tag: Int {
        didSet {
            textView?.tag = tag
        }
    }
    
    // MARK: UsedOnce
    
    var wasSetUp = false

    // MARK: LongFormEntryCollectionViewCell
    
    private(set) var identifier = ""
    private(set) var fieldDescription = ""
    private(set) var textView: UITextView?

    private var header: UILabel?
    private let viewModel = EditorStyleConstants()
    private var resigning = false

    func setup(with identifier: Identifier, value: String, description: String) {
        if wasSetUp {
            header?.text = identifier
            textView?.text = value
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
        
        self.textView = textView
        self.textView?.text = value
        
        if value.count > 0 {
            self.textView?.isEditable = false
            self.contentView.backgroundColor = StyleConstants.Color.gray
            self.textView?.backgroundColor = .clear
        }
        else {
            self.contentView.backgroundColor = viewModel.lightColor
        }
        
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
