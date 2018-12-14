//
//  UserEntryView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/14/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A simple view containing a static label and a textview for user input
/// Used for things like Character name
final class UserEntryView: UIView, UITextFieldDelegate {
    private let viewModel: UserEntryViewModel
    
    init(frame: CGRect, viewModel: UserEntryViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = viewModel.lightColor
        
        
        
        
        
    }
    
    private func label(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = viewModel.labelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = viewModel.darkColor
        label.textColor = viewModel.lightColor
        label.text = viewModel.labelText
        label.textAlignment = .center
        label.fitTextToBounds()
        
        return label
    }
    
    private func inputField(frame: CGRect) -> UITextField {
        let field = UITextField(frame: frame)
        field.font = viewModel.inputFont
        field.minimumFontSize = viewModel.inputMinimumSize
        field.adjustsFontSizeToFitWidth = true
        field.autocorrectionType = .no
        
        return field
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
