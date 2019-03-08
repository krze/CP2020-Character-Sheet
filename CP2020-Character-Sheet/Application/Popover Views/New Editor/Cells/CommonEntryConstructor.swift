//
//  CommonEntryConstructor.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 3/8/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A collection of functions that help construct common elements in user entry views.
struct CommonEntryConstructor {
    
    /// Style constants that dictate how the editor fields appear
    private static let styleConstants = EditorStyleConstants()
    
    /// Creates a view containg a label inset with margins according to the EditorStyleConstants
    ///
    /// - Parameters:
    ///   - size: Size of the view
    ///   - text: The text you wish to display in the label
    ///   - fullHeight: When true, the top and bottom margins will be set to 0
    /// - Returns: View containing the label
    static func headerView(size: CGSize, text: String, fullHeight: Bool = false) -> UIView {
        let labelViewFrame = CGRect(x: 0,
                                    y: 0,
                                    width: size.width,
                                    height: size.height)
        let labelViewMargins = styleConstants.createInsets(with: labelViewFrame, fullHeight: fullHeight)
        let labelView = UILabel.container(frame: labelViewFrame, margins: labelViewMargins, backgroundColor: styleConstants.lightColor, borderColor: nil, borderWidth: nil, labelMaker: headerLabel)
        labelView.label.text = "\(text):"

        return labelView.container
    }
    
    /// Creates a TextField for user entry
    ///
    /// - Parameters:
    ///   - frame: The frame in which to contain the textfield
    ///   - placeholder: The placeholder string to place in the textfield
    /// - Returns: UITextField
    static func textField(frame: CGRect, placeholder: String) -> UITextField {
        let field = UITextField(frame: CGRect(x: 0,
                                              y: 0,
                                              width: frame.width,
                                              height: frame.height)) // If something's screwed up check if dropping the size param broke this
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = styleConstants.inputFont
        field.backgroundColor = styleConstants.lightColor
        field.textColor = styleConstants.darkColor
        field.textAlignment = .left
        field.leftView = UIView(frame: CGRect(x: frame.minX, y: frame.minY, width: frame.width * styleConstants.paddingRatio, height: frame.height))
        field.text = placeholder
        field.autocorrectionType = .no
        field.autocapitalizationType = .sentences
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .done
        field.keyboardAppearance = .dark
        
        return field
    }
    
    /// Creates a info button popping up helper text.
    ///
    /// - Parameters:
    ///   - size: Size of the button
    ///   - action: A selector that responds to the button tap
    /// - Returns: UIButton
    static func helpButton(size: CGSize, action: Selector) -> UIButton {
        let button = UIButton(type: .infoDark)
        button.frame.size = size
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    // MARK: Private
    
    private static func headerLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = styleConstants.labelFont
        label.backgroundColor = styleConstants.lightColor
        label.textColor = styleConstants.darkColor
        label.textAlignment = .left
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return label
    }
}
