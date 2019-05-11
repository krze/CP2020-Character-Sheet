//
//  TitleCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 5/11/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Serves as a title bar and close button for whatever Editor you just loaded
final class TitleCollectionViewCell: UICollectionViewCell {
    
    private var dismiss: (() -> Void)?
    
    /// Sets up the cell with the title and the function to call to dismiss the popover
    ///
    /// - Parameters:
    ///   - title: Title to go in the label
    ///   - dismissal: Function to call to dismiss the UICollectionViewController the cell belongs to
    func setup(with title: String, dismissal: @escaping () -> Void) {
        self.dismiss = dismissal
        
        // Close Button
        
        let buttonWidth = contentView.frame.width * 0.25
        let elementHeight = contentView.frame.height - (contentView.frame.height * (StyleConstants.SizeConstants.textPaddingRatio * 2))
        let buttonFrame = CGRect(origin: .zero, size: CGSize(width: buttonWidth, height: elementHeight))
        let closeButton = self.closeButton(frame: buttonFrame)
        contentView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            closeButton.heightAnchor.constraint(equalToConstant: elementHeight),
            closeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            closeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(buttonWidth - 10))
            ])
        
        // Title label
        
        let titleWidth = contentView.frame.width * 0.50
        let titleLabel = CommonEntryConstructor.headerView(size: CGSize(width: titleWidth, height: elementHeight), text: title)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: titleWidth),
            titleLabel.heightAnchor.constraint(equalToConstant: elementHeight),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
    }
    
    @objc private func dismissalOnParent() {
        dismiss?()
    }
    
    private func closeButton(frame: CGRect) -> UIButton {
        let button = UIButton(frame: frame)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.setTitleColor(StyleConstants.Color.red, for: .normal)
        
        button.contentHorizontalAlignment = .center
        button.backgroundColor = StyleConstants.Color.light
        button.titleLabel?.font = StyleConstants.Font.defaultBold
        button.titleLabel?.backgroundColor = StyleConstants.Color.light
        button.titleLabel?.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        button.addTarget(self, action: #selector(dismissalOnParent), for: .touchUpInside)

        return button
    }
    
}
