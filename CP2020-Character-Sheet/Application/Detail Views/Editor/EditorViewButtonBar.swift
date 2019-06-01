//
//  EditorViewButtonBar.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/5/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A bar that contains confirm and dismiss buttons to make the editor view disappear. Confirming or dismissing will choose whether
/// to save or not save the values entered in the editor view.
final class EditorViewButtonBar: UIView {
    
    private(set) var dismissButton: UIButton = UIButton()
    private(set) var confirmButton: UIButton = UIButton()
    
    /// Creates a bar containing confirm and dismiss buttons to confirm or dismiss the editor.
    ///
    /// - Parameter frame: The frame for the bar
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        let sideInset = frame.width * 0.1
        let insets = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        
        var titles = Labels.allCases
        let buttonSpace = frame.inset(by: insets).width * 0.8
        let buttonSize = CGSize(width: (buttonSpace) / 2, height: frame.height)
        var finishedButtons = [UIButton]()
        
        while !titles.isEmpty {
            guard let title = titles.popLast() else { break }
            let frame = CGRect(origin: frame.origin, size: buttonSize)
            let button = self.button(frame: frame, title: title.rawValue, color: title.color())

            
            addSubview(button)
            
            let xAxisAnchor: NSLayoutConstraint = {
                switch title {
                case .Dismiss:
                    return button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -buttonSize.width)
                case .Confirm:
                    return button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: buttonSize.width)
                }
            }()
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: buttonSize.width),
                button.heightAnchor.constraint(equalToConstant: buttonSize.height),
                button.topAnchor.constraint(equalTo: topAnchor),
                xAxisAnchor
                ])
            
            finishedButtons.append(button)
            
            switch title {
            case .Dismiss:
                dismissButton = button
            case .Confirm:
                confirmButton = button
            }
        }
        
    }
    
    private func button(frame: CGRect, title: String, color: UIColor) -> UIButton {
        let button = UIButton(frame: frame)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        
        button.contentHorizontalAlignment = .center
        button.backgroundColor = StyleConstants.Color.light
        button.titleLabel?.font = StyleConstants.Font.defaultBold
        button.titleLabel?.backgroundColor = StyleConstants.Color.light
        button.titleLabel?.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum Labels: String, CaseIterable {
        case Dismiss, Confirm
        
        func color() -> UIColor {
            switch self {
            case .Dismiss:
                return StyleConstants.Color.red
            case .Confirm:
                return StyleConstants.Color.blue
            }
        }
    }
}
