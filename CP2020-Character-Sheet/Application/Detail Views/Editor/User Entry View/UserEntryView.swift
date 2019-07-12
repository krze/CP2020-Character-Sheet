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
final class UserEntryView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    let type: EntryType
    let identifier: Identifier
    
    var userInputValue: String? {
        if let selectedRow = selectedRow {
            return pickerChoices?[selectedRow]
        }
        
        return textField?.text
    }
    var delegate: UserEntryViewDelegate? {
        didSet {
            textField?.delegate = delegate
        }
    }
    
    // Text field Variables
    private (set) var textField: UITextField?
    
    // Picker view variables
    
    private let pickerChoices: [String]?
    private let pickerFrame: CGRect?
    private var dismissablePickerView: DismissablePickerView?
    private var roleButton: UIButton?
    private var selectedRow: Int?
    
    private let viewModel: UserEntryViewModel

    init(viewModel: UserEntryViewModel, frame: CGRect, windowForPicker: CGRect?) {
        type = viewModel.type
        identifier = viewModel.identifierText
        
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
    
    func forceEndEdting() {
        self.textField?.endEditing(true)
        self.dismissablePickerView?.pickerView?.endEditing(true)
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
        selectedRow = row
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = view as? UILabel ?? {
            let pickerLabel = UILabel()
            pickerLabel.font = viewModel.inputFont
            pickerLabel.textAlignment = .center
            
            return pickerLabel
            }()
        
        pickerLabel.text = pickerChoices?[row]
        
        return pickerLabel
    }
    
    // MARK: Private
    
    private func setupSubviews() {
        let stacked = viewModel.stacked
        
        let headerWidth = frame.width * viewModel.identifierWidthRatio
        let headerHeight = stacked ? viewModel.headerHeight + viewModel.descriptionHeight : frame.height
        let labelSize = CGSize(width: headerWidth, height: headerHeight)
        
        let labelView = stacked && !viewModel.descriptionText.isEmpty ? stackedHeaderWithDescription(sizeForBothViews: labelSize) : headerView(size: labelSize)
        
        if !stacked {
            addUnderline(to: labelView)
        }
        
        addSubview(labelView)
        NSLayoutConstraint.activate([
            labelView.heightAnchor.constraint(equalToConstant: headerHeight),
            labelView.widthAnchor.constraint(equalToConstant: headerWidth),
            labelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelView.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        let inputViewHeight = stacked ? viewModel.inputHeight : frame.height
        let inputViewWidth = frame.width * viewModel.inputWidthRatio
        let inputViewFrame = CGRect(x: headerWidth,
                                    y: headerHeight,
                                    width: inputViewWidth,
                                    height: inputViewHeight)
        let inputView = createInputView(for: type, frame: inputViewFrame)
        let inputViewTopAnchor = stacked ? labelView.bottomAnchor : topAnchor
        let inputViewLeadingAnchor = stacked ? leadingAnchor : labelView.trailingAnchor
        addSubview(inputView)
        NSLayoutConstraint.activate([
            inputView.heightAnchor.constraint(equalToConstant: inputViewHeight),
            inputView.widthAnchor.constraint(equalToConstant: inputViewWidth),
            inputView.leadingAnchor.constraint(equalTo: inputViewLeadingAnchor),
            inputView.topAnchor.constraint(equalTo: inputViewTopAnchor)
            ])
    }
    
    private func stackedHeaderWithDescription(sizeForBothViews size: CGSize) -> UIView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let header = headerView(size: CGSize(width: size.width, height: viewModel.headerHeight), fullHeight: true)
        let description = descriptionView(size: CGSize(width: size.width, height: viewModel.descriptionHeight), fullHeight: true)
        
        stackView.addArrangedSubview(header)
        stackView.addArrangedSubview(description)
        
        NSLayoutConstraint.activate([
            header.heightAnchor.constraint(equalToConstant: viewModel.headerHeight),
            header.widthAnchor.constraint(equalToConstant: size.width),
            description.heightAnchor.constraint(equalToConstant: viewModel.descriptionHeight),
            description.widthAnchor.constraint(equalToConstant: size.width)
            ])
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        
        return stackView
    }
    
    private func headerView(size: CGSize, fullHeight: Bool = false) -> UIView {
        let labelViewFrame = CGRect(x: 0,
                                    y: 0,
                                    width: size.width,
                                    height: size.height)
        let labelViewMargins = viewModel.createInsets(with: labelViewFrame, fullHeight: fullHeight)
        let labelView = UILabel.container(frame: labelViewFrame, margins: labelViewMargins, backgroundColor: viewModel.lightColor, borderColor: nil, borderWidth: nil, labelMaker: headerLabel)
        
        labelView.label.textAlignment = .left
        return labelView.label
    }
    
    private func descriptionView(size: CGSize, fullHeight: Bool = false) -> UIView {
        let labelViewFrame = CGRect(x: 0,
                                    y: 0,
                                    width: size.width,
                                    height: size.height)
        let labelViewMargins = viewModel.createInsets(with: labelViewFrame, fullHeight: fullHeight)
        let labelView = UILabel.container(frame: labelViewFrame, margins: labelViewMargins, backgroundColor: viewModel.lightColor, borderColor: nil, borderWidth: nil, labelMaker: headerLabel)
        labelView.label.text = viewModel.descriptionText
        labelView.label.font = viewModel.descriptionFont?.withSize(12.0)
        labelView.label.numberOfLines = 0
        labelView.label.textAlignment = .left
        return labelView.label
    }
    
    private func createInputView(for: EntryType, frame: CGRect) -> UIView {
        switch type {
        case .Text, .LongFormText, .Static:
            let textField = self.textField(frame: frame)
            self.textField = textField
            
            return textField
        case .Integer:
            let integerField = textField(frame: frame)
            integerField.keyboardType = .numberPad
            
            if viewModel.placeholder == String("\(0)") {
                integerField.text = ""
                integerField.placeholder = viewModel.placeholder
            }
            
            textField = integerField

            return integerField
        case .Picker:
            guard let pickerFrame = pickerFrame else {
                return UIView()
            }
            
            dismissablePickerView = DismissablePickerView(frame: pickerFrame, viewModel: viewModel)
            dismissablePickerView?.pickerView?.delegate = self
            dismissablePickerView?.pickerView?.dataSource = self
            dismissablePickerView?.dismissButton?.addTarget(self, action: #selector(pickerWasClosed), for: .touchUpInside)
            dismissablePickerView?.pickerView?.selectRow(pickerChoices?.firstIndex(of: viewModel.placeholder) ?? 0, inComponent: 0, animated: true)
            
            let button = pickerButton(frame: frame)
            
            button.addTarget(self, action: #selector(pickerButtonWasPressed), for: .touchUpInside)
            roleButton = button
            return button
        case .SuggestedText(let suggestions):
            print("Not done yet")
            print(suggestions)
            return UIView()
        case .EnforcedChoiceText(let requirements):
            print("Not done yet")
            print(requirements)
            return UIView()
        }
    }
    
    private func headerLabel(frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = viewModel.labelFont
        label.backgroundColor = viewModel.lightColor
        label.textColor = viewModel.darkColor
        label.text = "\(viewModel.identifierText):"
        label.textAlignment = .right
        label.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return label
    }
    
    private func textField(frame: CGRect) -> UITextField {
        let field = UITextField(frame: frame)

        let inputFont: UIFont? = {
            switch type {
            case .Integer:
                return viewModel.inputFont?.withSize(frame.height / 2)
            default:
                return viewModel.inputFont
            }
        }()
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = inputFont
        field.backgroundColor = viewModel.lightColor
        field.textColor = viewModel.darkColor
        field.textAlignment = .left
        field.leftView = UIView(frame: CGRect(x: frame.minX, y: frame.minY, width: frame.width * viewModel.paddingRatio, height: frame.height))
        field.text = viewModel.placeholder
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .done
        field.keyboardAppearance = .dark
        
        addUnderline(to: field)
        
        return field
    }
    
    private func pickerButton(frame: CGRect) -> UIButton {
        let bgView = UIView(frame: frame)
        addUnderline(to: bgView)
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.directionalLayoutMargins = viewModel.createInsets(with: frame)
        button.setTitle(viewModel.placeholder.isEmpty ? "Tap to Choose" : viewModel.placeholder, for: .normal)
        button.setTitleColor(viewModel.confirmColor, for: .normal)
        button.setBackgroundImage(bgView.asImage(), for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = viewModel.lightColor
        button.titleLabel?.font = viewModel.labelFont
        button.titleLabel?.backgroundColor = viewModel.lightColor
        button.titleLabel?.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        
        return button
    }
    
    @objc private func pickerButtonWasPressed() {
        guard let dismissablePickerView = dismissablePickerView else {
            return
        }
        
        // If the picker appears and the user confirms the first choice without moving the picker, the choice
        // wouldn't be recorded. This is to ensure that once the picker is opened for the first time, there will
        // be an input value even if they do not scroll through the picker.
        if userInputValue == nil {
            selectedRow = 0
        }
        
        delegate?.pickerViewWillDisplay(identifier: identifier, dismissablePickerView: dismissablePickerView)
    }
    
    @objc private func pickerWasClosed() {
        guard let dismissablePickerView = dismissablePickerView else { return }
        
        if let chosenRole = userInputValue {
            roleButton?.setTitle(chosenRole, for: .normal)
            roleButton?.titleLabel?.fitTextToBounds(maximumSize: StyleConstants.Font.maximumSize)
        }
        
        delegate?.pickerViewWillClose(identifier: identifier, dismissablePickerView: dismissablePickerView)
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
