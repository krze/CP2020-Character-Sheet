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
    static func headerView(size: CGSize, text: String, fullHeight: Bool = false, margins: NSDirectionalEdgeInsets? = nil, labelMaker: ((CGRect) -> UILabel)? = nil) -> UIView {
        let labelViewFrame = CGRect(x: 0,
                                    y: 0,
                                    width: size.width,
                                    height: size.height)
        let labelViewMargins = margins ?? styleConstants.createInsets(with: labelViewFrame, fullHeight: fullHeight)
        let labelView = UILabel.container(frame: labelViewFrame, margins: labelViewMargins, backgroundColor: styleConstants.lightColor, borderColor: nil, borderWidth: nil, labelMaker: labelMaker ?? headerLabel)
        labelView.label.text = "\(text):"
        
        labelView.container.backgroundColor = .clear
        labelView.label.backgroundColor = .clear
        
        return labelView.container
    }
    
    /// Creates a TextField for user entry
    ///
    /// - Parameters:
    ///   - frame: The frame in which to contain the textfield
    ///   - placeholder: The placeholder string to place in the textfield
    ///   - leftView: Custom left view, optional
    /// - Returns: UITextField
    static func textField(frame: CGRect, placeholder: String, leftView: UIView? = nil) -> UITextField {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = styleConstants.inputFont
        field.backgroundColor = styleConstants.lightColor
        field.textColor = styleConstants.darkColor
        field.textAlignment = .left
        field.leftView = leftView ?? UIView(frame: CGRect(x: frame.minX, y: frame.minY, width: frame.width * styleConstants.paddingRatio, height: frame.height))
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

    /// Creates a simple cell that contains a header label and a value below it that's expected to be mutable. An example of this from the book's character sheet would be the cells
    /// you typically see to represent the value of armor in each location.
    ///
    /// - Parameters:
    ///   - frame: The frame to use for the whole view
    ///   - labelHeightRatio: The height ratio for the header label. The value label fills the rest of the space.
    ///   - headerText: The text that goes in the header label
    static func simpleHeaderValueCell(frame: CGRect, labelHeightRatio: CGFloat, headerText: String?) -> (wholeView: UIView, valueLabel: UILabel) {
        let cell = UIView(frame: frame)
        cell.translatesAutoresizingMaskIntoConstraints = false
        let containerFrame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height * labelHeightRatio)
        let insets = NSDirectionalEdgeInsets(top: frame.height * StyleConstants.SizeConstants.textPaddingRatio,
                                             leading: frame.width * StyleConstants.SizeConstants.textPaddingRatio,
                                             bottom: frame.height * StyleConstants.SizeConstants.textPaddingRatio,
                                             trailing: frame.width * StyleConstants.SizeConstants.textPaddingRatio)
        // Quick function to make this work better with the label container
        func makeLabel(frame: CGRect) -> UILabel {
            let label = headerLabel(frame: frame, text: headerText)
            label.backgroundColor = StyleConstants.Color.dark
            label.textColor = StyleConstants.Color.light
            label.textAlignment = .center
            return label
        }

        let labelContainer = UILabel.container(frame: containerFrame,
                                               margins: insets,
                                               backgroundColor: StyleConstants.Color.dark,
                                               borderColor: nil,
                                               borderWidth: nil,
                                               labelMaker: makeLabel)

        cell.addSubview(labelContainer.container)

        NSLayoutConstraint.activate([
            labelContainer.container.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            labelContainer.container.topAnchor.constraint(equalTo: cell.topAnchor),
            labelContainer.container.widthAnchor.constraint(equalToConstant: containerFrame.width),
            labelContainer.container.heightAnchor.constraint(equalToConstant: containerFrame.height)
            ])


        let valueLabelRatio = 1.0 - labelHeightRatio
        let valueLabelFrame = CGRect(x: 0.0, y: labelContainer.container.frame.height,
                                     width: frame.width, height: frame.height * valueLabelRatio)
        let valueLabel = self.valueLabel(frame: valueLabelFrame)

        cell.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            valueLabel.topAnchor.constraint(equalTo: labelContainer.container.bottomAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: valueLabelFrame.width),
            valueLabel.heightAnchor.constraint(equalToConstant: valueLabelFrame.height)
            ])

        return (cell, valueLabel)
    }
    
    // MARK: Private

    private static func headerLabel(frame: CGRect) -> UILabel {
        return headerLabel(frame: frame, text: nil)
    }

    private static func headerLabel(frame: CGRect, text: String? = nil) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = text
        label.font = styleConstants.labelFont
        label.backgroundColor = styleConstants.lightColor
        label.textColor = styleConstants.darkColor
        label.textAlignment = .left
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return label
    }

    private static func valueLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = StyleConstants.Font.defaultBold
        label.textColor = StyleConstants.Color.dark
        label.backgroundColor = StyleConstants.Color.light
        label.layer.borderColor = StyleConstants.Color.dark.cgColor
        label.layer.borderWidth = StyleConstants.SizeConstants.borderWidth
        label.textAlignment = .center
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)

        return label
    }
}
