//
//  UserEntryView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A custom view that allows for user entry. Provides a label that describes the user input, and
/// an input field that allows user input in various forms, all returnable as a String.
final class UserEntryView: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let type: EntryType
    let identifier: String
    
    private(set) var userInputValue: String?
    
    // Picker view variables
    
    var delegate: UserEntryViewDelegate?
    
    private let pickerChoices: [String]?
    private let pickerFrame: CGRect?
    private var pickerView: UIPickerView?
    
    private let viewModel: UserEntryViewModel

    init(viewModel: UserEntryViewModel, frame: CGRect, windowForPicker: CGRect?) {
        type = viewModel.type
        identifier = viewModel.labelText
        
        switch type {
        case .Picker(let strings):
            pickerChoices = strings
            pickerFrame = windowForPicker
        default:
            pickerChoices = nil
            pickerFrame = nil
        }
        
        self.viewModel = viewModel
        
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        setupSubviews()
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerChoices?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let choices = pickerChoices, choices.indices.contains(row) {
            return choices[row]
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userInputValue = pickerChoices?[row]
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        userInputValue = textField.text
        delegate?.textFieldDidFinishEditing(identifier: identifier)
    }
    
    // MARK: Private
    
    private func setupSubviews() {
        let labelViewWidth = frame.width * viewModel.labelWidthRatio
        let labelViewFrame = CGRect(x: frame.minX,
                                    y: frame.minY,
                                    width: labelViewWidth,
                                    height: frame.height)
        let labelViewMargins = viewModel.createInsets(with: labelViewFrame)
        let labelView = UILabel.container(frame: labelViewFrame, margins: labelViewMargins, backgroundColor: viewModel.lightColor, borderColor: nil, borderWidth: nil, labelMaker: label)
        
        addUnderline(to: labelView.container)
        
        addSubview(labelView.container)
        NSLayoutConstraint.activate([
            labelView.container.heightAnchor.constraint(equalToConstant: frame.height),
            labelView.container.widthAnchor.constraint(equalToConstant: labelViewWidth),
            labelView.container.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelView.container.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        let inputViewWidth = frame.width * viewModel.inputWidthRatio
        let inputViewFrame = CGRect(x: labelViewFrame.width,
                                    y: frame.height,
                                    width: inputViewWidth,
                                    height: frame.height)
        let inputView = createInputView(for: type, frame: inputViewFrame)
        
        addSubview(inputView)
        NSLayoutConstraint.activate([
            inputView.heightAnchor.constraint(equalToConstant: frame.height),
            inputView.widthAnchor.constraint(equalToConstant: inputViewWidth),
            inputView.leadingAnchor.constraint(equalTo: labelView.container.trailingAnchor),
            inputView.topAnchor.constraint(equalTo: topAnchor)
            ])
    }
    
    private func createInputView(for: EntryType, frame: CGRect) -> UIView {
        switch type {
        case .Text:
            return textField(frame: frame)
        case .Integer:
            let integerField = textField(frame: frame)
            
            integerField.keyboardType = .numberPad
            return integerField
        case .Picker:
            guard let pickerFrame = pickerFrame else {
                return UIView()
            }
            
            pickerView = picker(frame: pickerFrame)
            let button = pickerButton(frame: frame)
            
            button.addTarget(self, action: #selector(pickerButtonWasPressed), for: .touchUpInside)
            
            return button
        }
    }
    
    private func label(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = viewModel.labelFont
        label.backgroundColor = viewModel.lightColor
        label.textColor = viewModel.darkColor
        label.text = "\(viewModel.labelText):"
        label.textAlignment = .right
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return label
    }
    
    private func textField(frame: CGRect) -> UITextField {
        let field = UITextField(frame: frame)
        let margins = viewModel.createInsets(with: frame)
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.directionalLayoutMargins = margins
        field.font = viewModel.inputFont
        field.backgroundColor = viewModel.lightColor
        field.textColor = viewModel.darkColor
        field.textAlignment = .left
        field.leftView = UIView(frame: CGRect(x: frame.minX, y: frame.minY, width: frame.width * viewModel.paddingRatio, height: frame.height))
        
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        
        addUnderline(to: field)
        field.delegate = self
        
        return field
    }
    
    private func picker(frame: CGRect) -> UIPickerView {
        let pickerView = UIPickerView(frame: frame)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        return pickerView
    }
    
    private func pickerButton(frame: CGRect) -> UIButton {
        let bgView = UIView(frame: frame)
        addUnderline(to: bgView)
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.directionalLayoutMargins = viewModel.createInsets(with: frame)
        button.setTitle("Choose a class", for: .normal)
        button.setTitleColor(viewModel.highlightColor, for: .normal)
        button.setBackgroundImage(bgView.asImage(), for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = viewModel.lightColor
        button.titleLabel?.font = viewModel.labelFont
        button.titleLabel?.backgroundColor = viewModel.lightColor
        button.titleLabel?.textColor = viewModel.highlightColor
        button.titleLabel?.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return button
    }
    
    @objc private func pickerButtonWasPressed() {
        guard let pickerView = pickerView else {
            return
        }
        
        delegate?.pickerViewWillDisplay(identifier: identifier, pickerView: pickerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Adds a bottom underline to the desired view
    ///
    /// - Parameter view: The view to add the border to
    private func addUnderline(to view: UIView) {
        let border = CALayer()
        let borderWidth = StyleConstants.SizeConstants.borderWidth
        border.borderColor = viewModel.darkColor.cgColor
        border.frame = CGRect(x: 0,
                              y: view.frame.height - borderWidth,
                              width: view.frame.width,
                              height: view.frame.height)
        
        border.borderWidth = borderWidth
        view.layer.addSublayer(border)
        view.layer.masksToBounds = true
    }
    
}

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
