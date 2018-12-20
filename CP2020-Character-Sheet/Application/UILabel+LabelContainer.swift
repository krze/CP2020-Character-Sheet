//
//  UILabel+LabelContainer.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/9/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// Creates a container for a label that allows for padding.
    ///
    /// - Parameters:
    ///   - frame: Frame for the container
    ///   - margins: NSDirectionalEdgeInsets representing the padding between the container and the label
    ///   - backgroundColor: Background Color for the container
    ///   - borderColor: Optional border color for the container
    ///   - borderWidth: Optional border width for the container
    ///   - labelMaker: A function that takes a CGRect frame and produces a UILabel
    /// - Returns: Tuple containing the reference to the container, and the label
    static func container(frame: CGRect, margins: NSDirectionalEdgeInsets, backgroundColor: UIColor, borderColor: UIColor?, borderWidth: CGFloat?, labelMaker: (CGRect) -> UILabel) -> (container: UIView, label: UILabel) {
        let container = UIView(frame: frame)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.directionalLayoutMargins = margins
        container.backgroundColor = backgroundColor
        container.layer.borderColor = borderColor?.cgColor
        container.layer.borderWidth = borderWidth ?? 0.0
        
        let labelFrame = CGRect(x: container.frame.minX,
                                y: container.frame.minY,
                                width: container.frame.width - container.directionalLayoutMargins.leading - container.directionalLayoutMargins.trailing,
                                height: container.frame.height - container.directionalLayoutMargins.top - container.directionalLayoutMargins.bottom)
        let label = labelMaker(labelFrame)
        
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: labelFrame.width),
            label.heightAnchor.constraint(equalToConstant: labelFrame.height),
            label.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
            label.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor)
            ])
        
        return (container, label)
    }
   
}
