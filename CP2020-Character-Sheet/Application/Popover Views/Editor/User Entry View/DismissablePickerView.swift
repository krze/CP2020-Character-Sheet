//
//  DismissablePickerView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/1/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class DismissablePickerView: UIView {
    
    var pickerView: UIPickerView?
    var dismissButton: UIButton?
    private let viewModel: UserEntryViewModel

    init(frame: CGRect, viewModel: UserEntryViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = viewModel.lightColor
        let pickerFrameWidth = frame.width * 0.5
        let pickerFrameX = pickerFrameWidth - (pickerFrameWidth * 0.5)
        let pickerFrame = CGRect(x: pickerFrameX, y: 0, width: pickerFrameWidth, height: frame.height)
        let pickerView = picker(frame: pickerFrame)
        
        addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.widthAnchor.constraint(equalToConstant: pickerFrameWidth),
            pickerView.heightAnchor.constraint(equalToConstant: frame.height),
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        
        let closePickerButtonWidth = frame.width * 0.2
        let closePickerButtonHeight = closePickerButtonWidth * 0.5
        let closePickerButtonX = pickerFrameX + pickerFrameWidth
        let closePickerButtonFrame = CGRect(x: closePickerButtonX, y: 0,
                                            width: closePickerButtonWidth, height: closePickerButtonHeight)
        let dismissButton = dismissPickerButton(frame: closePickerButtonFrame)
        
        addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.widthAnchor.constraint(equalToConstant: closePickerButtonWidth),
            dismissButton.heightAnchor.constraint(equalToConstant: closePickerButtonHeight),
            dismissButton.topAnchor.constraint(equalTo: pickerView.topAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: pickerView.trailingAnchor)
            ])
        
        
        self.pickerView = pickerView
        self.dismissButton = dismissButton

        // TODO: When this is finished, must remember to assign pickerview delegate and datasource, as well as button target.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func picker(frame: CGRect) -> UIPickerView {
        let pickerView = UIPickerView(frame: frame)
        pickerView.backgroundColor = viewModel.lightColor
        pickerView.showsSelectionIndicator = true
        return pickerView
    }
    
    private func dismissPickerButton(frame: CGRect) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.directionalLayoutMargins = viewModel.createInsets(with: frame)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(viewModel.highlightColor, for: .normal)
        
        button.backgroundColor = viewModel.lightColor
        button.titleLabel?.font = viewModel.labelFont
        button.titleLabel?.backgroundColor = viewModel.lightColor
        button.titleLabel?.textColor = viewModel.highlightColor
        button.titleLabel?.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return button
    }
}
