//
//  DiceRollEntryCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/30/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class DiceRollEntryCollectionViewCell: UICollectionViewCell, DiceRollCollectionViewCell {
    
    private(set) var diceRoll: DiceRoll?

    private(set) var identifier = ""
    private(set) var  fieldDescription = ""
    
    private let viewModel = EditorStyleConstants()
    private var header: UIView?
    private var stackView: UIStackView?
    
    private let diceRollFont = StyleConstants.Font.defaultFont?.withSize(28.0)

    // Number of dice
    private(set) var numberTextField: UITextField?
    // Sides per dice
    private(set) var sidesTextField: UITextField?
    // Modifier
    private(set) var modifierTextField: UITextField?
    
    // The plus sign
    private(set) var plusSignLabel: UITextField?
    
    func setup(with identifier: Identifier, description: String, placeholder: DiceRoll?) {
        self.identifier = identifier
        self.fieldDescription = description
        diceRoll = placeholder
        
        let headerView = CommonEntryConstructor.headerView(size: .zero, text: identifier)
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
        
        header = headerView
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -(sidePadding * 2)),
            stackView.heightAnchor.constraint(equalToConstant: viewModel.entryHeight)
            ])
        
        contentView.backgroundColor = StyleConstants.Color.light
        setupDiceStackView(stackView, placeholder: placeholder)
    }
    
    /// Call this to set the DiceRoll property with the latest entry provided
    func assembleDiceRoll() {
        guard let numberString = numberTextField?.text,
            let number = Int(numberString),
            let sidesString = sidesTextField?.text,
            let sides = Int(sidesString) else {
                return
        }
        
        let modifier = Int(modifierTextField?.text ?? "") ?? 0
        
        diceRoll = DiceRoll(number: number, sides: sides, modifier: modifier)
        
        // NEXT: Create a verifier for this cell. We'll probably have to respond to textfield changes to ensure we're verifying correctly.
    }
    
    override func prepareForReuse() {
        diceRoll = nil
        identifier = ""
        fieldDescription = ""
        header = nil
        stackView = nil
    }
    
    private func setupDiceStackView(_ stackView: UIStackView, placeholder: DiceRoll?) {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        
        let digitEntrySize = "00".size(withAttributes: [.font: diceRollFont as Any])
        let digitEntryFrame = CGRect(origin: .zero, size: digitEntrySize)
        
        let numberEntryView = digitEntryField(frame: digitEntryFrame, alignment: .right)
        numberEntryView.text = "\(placeholder?.number ?? 0)"
        numberEntryView.widthAnchor.constraint(equalToConstant: digitEntrySize.width).isActive = true
        numberEntryView.heightAnchor.constraint(equalToConstant: digitEntrySize.height).isActive = true
        stackView.addArrangedSubview(numberEntryView)
        numberTextField = numberEntryView
        
        let d = "D"
        let dSize = d.size(withAttributes: [.font: diceRollFont as Any])
        let dFrame = CGRect(origin: .zero, size: dSize)
        let dView = digitEntryField(frame: dFrame, alignment: .center)
        dView.isUserInteractionEnabled = false
        dView.font = diceRollFont
        dView.text = d
        dView.heightAnchor.constraint(equalToConstant: digitEntrySize.height).isActive = true
        
        stackView.addArrangedSubview(dView)
        
        let sidesEntryView = digitEntryField(frame: digitEntryFrame, alignment: .left)
        sidesEntryView.text = "\(placeholder?.sides ?? 0)"
        sidesEntryView.widthAnchor.constraint(equalToConstant: digitEntrySize.width).isActive = true
        
        stackView.addArrangedSubview(sidesEntryView)
        sidesTextField = sidesEntryView
        
        let plus = "+"
        let plusSize = plus.size(withAttributes: [.font: diceRollFont as Any])
        let plusFrame = CGRect(origin: .zero, size: plusSize)
        let plusView = digitEntryField(frame: plusFrame, alignment: .center)
        plusView.isUserInteractionEnabled = false
        plusView.font = diceRollFont
        plusView.text = plus
        plusView.heightAnchor.constraint(equalToConstant: digitEntrySize.height).isActive = true
        
        plusSignLabel = plusView
        
        stackView.addArrangedSubview(plusView)
        
        let modifierEntryView = digitEntryField(frame: digitEntryFrame, alignment: .left)
        modifierEntryView.text = {
            if let existingModifier = placeholder?.modifier {
                return "\(existingModifier)"
            }
            
            return ""
        }()
        modifierEntryView.widthAnchor.constraint(equalToConstant: digitEntrySize.width * 3).isActive = true
        modifierEntryView.heightAnchor.constraint(equalToConstant: digitEntrySize.height).isActive = true
        stackView.addArrangedSubview(modifierEntryView)
        modifierTextField = modifierEntryView
        
        let rightFillerView = UIView(frame: stackView.bounds)
        stackView.addArrangedSubview(rightFillerView)
        
        let backgroundView = UIView(frame: stackView.bounds)
        backgroundView.backgroundColor = StyleConstants.Color.light
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.insertSubview(backgroundView, at: 0)
    }
    
    private func digitEntryField(frame: CGRect, alignment: NSTextAlignment) -> UITextField {
        let textField = UITextField(frame: frame)
        textField.font = diceRollFont
        textField.textAlignment = alignment
        textField.textColor = StyleConstants.Color.dark
        textField.backgroundColor = StyleConstants.Color.light
        textField.keyboardType = .decimalPad
        textField.keyboardAppearance = .dark
        textField.addDoneButtonOnKeyboard()
        return textField
    }
    
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
