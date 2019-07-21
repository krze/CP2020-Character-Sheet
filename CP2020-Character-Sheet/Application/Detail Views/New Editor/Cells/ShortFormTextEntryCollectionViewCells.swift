//
//  ShortFormTextEntryCollectionViewCells.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

// This file contains all the single-line entry views. I don't like subclassing,
// and this should be re-worked for composition, but this was a fast MVP build to
// test out the revamped editor.

import UIKit

/// A single-line textfield that accepts user entry without validation
class TextEntryCollectionViewCell: UserEntryCollectionViewCell, UITextFieldDelegate {
    weak var delegate: UserEntryDelegate?
    
    var enteredValue: String? {
        return textField?.text
    }

    private(set) var identifier = ""
    private var header: UILabel?
    private var fieldDescription = ""

    fileprivate(set) var entryIsValid = true
    fileprivate let viewModel = EditorStyleConstants()
    fileprivate var textField: UITextField?
    
    private var resigning = false

    func setup(with identifier: Identifier, placeholder: String, description: String) {
        self.identifier = identifier
        self.fieldDescription = description
        
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
        
        let textField = CommonEntryConstructor.textField(frame: .zero, placeholder: placeholder)
        
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            textField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -(sidePadding * 2)),
            textField.heightAnchor.constraint(equalToConstant: viewModel.entryHeight)
            ])

        textField.delegate = self
        self.textField = textField
        self.contentView.backgroundColor = viewModel.lightColor
    }
    
    func makeFirstResponder() {
        textField?.becomeFirstResponder()
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resigning = textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.entryDidFinishEditing(identifier: identifier, value: enteredValue, moveToNextField: resigning)
        resigning = false
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideWarning()
    }

    // MARK: Private

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
        alert.addAction(UIAlertAction(title: SkillStrings.dismissHelpPopoverButtonText, style: .default, handler: nil))
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }

    fileprivate func showWarning() {
        textField?.backgroundColor = viewModel.redColor.withAlphaComponent(viewModel.fadedFillColorAlpha)
    }

    fileprivate func hideWarning() {
        if textField?.backgroundColor != viewModel.lightColor {
            textField?.backgroundColor = viewModel.lightColor
        }
    }
}

// Displays text while disabling the ability to edit the field. Use this field when popping an editor
// that mixes both editable and non-editable fields (i.e. editing an existing skill), or if you need
// to display a detail view without allowing the player to edit the fields
final class StaticEntryCollectionViewCell: TextEntryCollectionViewCell {
    
    override func setup(with identifier: Identifier, placeholder: String, description: String) {
        super.setup(with: identifier, placeholder: placeholder, description: description)
        textField?.isUserInteractionEnabled = false
    }
    
}

/// A single-line textfield that accepts user entry, validating the entry to be an integer
final class IntegerEntryCollectionViewCell: TextEntryCollectionViewCell {

    override func setup(with identifier: Identifier, placeholder: String, description: String) {
        super.setup(with: identifier, placeholder: placeholder, description: description)
        textField?.keyboardType = .numberPad

        if let existingValue = textField?.text {
            validate(userEntry: existingValue)
        }
    }

    override func textFieldDidEndEditing(_ textField: UITextField) {
        guard let userEntry = textField.text else { return }

        validate(userEntry: userEntry)
        
        if entryIsValid {
            super.textFieldDidEndEditing(textField)
        }
    }

    private func entryIsPositiveInteger(_ userEntry: String) -> Bool {
        guard !userEntry.isEmpty else {
            return false
        }

        if let userEntryValue = Int(userEntry), userEntryValue >= 0 {
            return true
        }

        return false
    }

    private func validate(userEntry: String) {
        guard entryIsPositiveInteger(userEntry) else {
            entryIsValid = false
            showWarning()
            return
        }

        entryIsValid = true
        hideWarning()
    }

}

class SuggestedTextCollectionViewCell: TextEntryCollectionViewCell {
    var suggestedMatches = [String]()
    private var autoCompleteCharacterCount = 0
    private var timer = Timer()

    override func setup(with identifier: Identifier, placeholder: String, description: String) {
        super.setup(with: identifier, placeholder: placeholder, description: description)
    }

    // MARK: UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }

        guard let text = textField.text?.capitalized as NSString? else { return false }
        let subString = format(subString: text.replacingCharacters(in: range, with: string))

        if subString.isEmpty {
            resetValues()
        } else {
            searchAutocompleteEntries(with: subString)
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if reason == .committed, let acceptedChoice = textField.attributedText?.string {
            textField.attributedText = nil
            textField.text = acceptedChoice
            textField.textColor = viewModel.darkColor
        }
    }

    // MARK: Private

    private func format(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized
        return formatted
    }

    private func resetValues() {
        autoCompleteCharacterCount = 0
        textField?.text = ""
    }

    private func searchAutocompleteEntries(with userQuery: String) {
        let suggestions = autocompleteSuggestions(for: userQuery)

        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                let autocompleteResult = self.formatAutocompleteResult(substring: userQuery, possibleMatches: suggestions)
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery: userQuery)
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery)
            })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                self.textField?.text = userQuery
            })
            autoCompleteCharacterCount = 0
        }
    }

    private func autocompleteSuggestions(for userText: String) -> [String]{
        return suggestedMatches.filter({ suggestedMatch in
            if let range = suggestedMatch.range(of: userText) {
                return range.lowerBound == suggestedMatch.startIndex
            }

            return false
        })
    }

    private func putColourFormattedTextInTextField(autocompleteResult: String, userQuery: String) {
        let styledString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        styledString.addAttribute(.foregroundColor, value: viewModel.grayColor, range: NSRange(location: userQuery.count,length: autocompleteResult.count))
        self.textField?.attributedText = styledString
    }

    private func moveCaretToEndOfUserQueryPosition(userQuery: String) {
        guard let beginning = textField?.beginningOfDocument else { return }

        if let newPosition = textField?.position(from: beginning, offset: userQuery.count) {
            self.textField?.selectedTextRange = self.textField?.textRange(from: newPosition, to: newPosition)
        }
    }

    private func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        guard var autoCompleteResult = possibleMatches.first else {
            return substring
        }

        autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
    }

}

final class EnforcedTextCollectionViewCell: SuggestedTextCollectionViewCell {

    override func setup(with identifier: Identifier, placeholder: String, description: String) {
        super.setup(with: identifier, placeholder: placeholder, description: description)
    }

    override func showWarning() {
        super.showWarning()
        guard let userEntry = textField?.text else { return }
        var choices = ""

        suggestedMatches.enumerated().forEach { index, choice in
            choices.append(contentsOf: choice)

            if suggestedMatches[index] != suggestedMatches.last {
                choices.append(contentsOf: ", ")
            }
        }

        let alert = UIAlertController(title: "\(userEntry) is an invalid choice", message: "Please select one of the following:\n\(choices)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: SkillStrings.dismissHelpPopoverButtonText, style: .default, handler: nil))
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }

    // MARK: UITextFieldDelegate

    override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        super.textFieldDidEndEditing(textField, reason: reason)
        guard let userEntry = textField.text else { return }
        validate(userEntry: userEntry)
    }

    // MARK: Private

    private func validate(userEntry: String) {
        if suggestedMatches.contains(userEntry) {
            entryIsValid = true
            hideWarning()
        }
        else {
            entryIsValid = false
            showWarning()
        }
    }
}
