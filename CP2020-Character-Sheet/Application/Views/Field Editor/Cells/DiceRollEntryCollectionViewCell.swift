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
    
    // Number of dice
    private(set) var numberTextField: UITextField?
    // Sides per dice
    private(set) var sidesTextField: UITextField?
    // Modifier
    private(set) var modifierTextField: UITextField?
    
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
        
        setupDiceStackView(stackView)
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
    
    private func setupDiceStackView(_ stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
        let digitEntrySize = "00".size(withAttributes: [.font: StyleConstants.Font.defaultFont as Any])
        let digitEntryFrame = CGRect(origin: .zero, size: digitEntrySize)
        
        let numberEntryView = digitEntryField(frame: digitEntryFrame, alignment: .right)
        
        stackView.addArrangedSubview(numberEntryView)
        numberTextField = numberEntryView
        
        let d = "D"
        let dSize = d.size(withAttributes: [.font: StyleConstants.Font.defaultFont as Any])
        let dFrame = CGRect(origin: .zero, size: dSize)
        let dMargins = viewModel.createInsets(with: dFrame)
        let dView = UILabel.container(frame: dFrame,
                                      margins: dMargins,
                                      backgroundColor: StyleConstants.Color.light,
                                      borderColor: nil,
                                      borderWidth: nil,
                                      labelMaker: CommonEntryConstructor.headerLabel(frame:))
        
        stackView.addArrangedSubview(dView.container)
        
        let sidesEntryView = digitEntryField(frame: digitEntryFrame, alignment: .left)
        
        stackView.addArrangedSubview(sidesEntryView)
        sidesTextField = sidesEntryView
        
        let plus = "+"
        let plusSize = plus.size(withAttributes: [.font: StyleConstants.Font.defaultFont as Any])
        let plusFrame = CGRect(origin: .zero, size: plusSize)
        let plusMargins = viewModel.createInsets(with: dFrame)
        let plusView = UILabel.container(frame: plusFrame,
                                         margins: plusMargins,
                                         backgroundColor: StyleConstants.Color.light,
                                         borderColor: nil,
                                         borderWidth: nil,
                                         labelMaker: CommonEntryConstructor.headerLabel(frame:))
        
        stackView.addArrangedSubview(plusView.container)
        
        let modifierEntryView = digitEntryField(frame: digitEntryFrame, alignment: .center)
        
        stackView.addArrangedSubview(modifierEntryView)
        modifierTextField = modifierEntryView
    }
    
    private func digitEntryField(frame: CGRect, alignment: NSTextAlignment) -> UITextField {
        let textField = UITextField(frame: frame)
        textField.font = StyleConstants.Font.defaultFont
        textField.textAlignment = alignment
        textField.textColor = StyleConstants.Color.dark
        textField.backgroundColor = StyleConstants.Color.light
        textField.keyboardType = .decimalPad
        
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
