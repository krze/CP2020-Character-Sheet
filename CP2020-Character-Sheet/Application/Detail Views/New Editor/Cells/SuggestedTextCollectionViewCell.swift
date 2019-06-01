//
//  SuggestedTextCollectionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A user entry view of EntryType.SuggestedText or EntryType.EnforcedChoiceText
final class SuggestedTextCollectionViewCell: UserEntryCollectionViewCell, UITextFieldDelegate {

    var enteredValue: String? {
        return textField?.text
    }
    var suggestedMatches = [String]()

    private var identifier = ""

    private var textField: UITextField?
    private var header: UILabel?
    private var fieldDescription = ""
    private let viewModel = EditorStyleConstants()

    private var autoCompleteCharacterCount = 0
    private var timer = Timer()

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
        textField.delegate = self
        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            textField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -(sidePadding * 2)),
            textField.heightAnchor.constraint(equalToConstant: viewModel.entryHeight)
            ])

        self.textField = textField
        self.contentView.backgroundColor = viewModel.lightColor
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
        alert.addAction(UIAlertAction(title: SkillStrings.dismissHelpPopoverButtonText, style: .default, handler: nil))
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text?.capitalized as NSString? else { return false }
        let subString = format(subString: text.replacingCharacters(in: range, with: string))

        if subString.isEmpty {
            resetValues()
        } else {
            searchAutocompleteEntries(with: subString)
        }
        return true
    }

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
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(.foregroundColor, value: viewModel.grayColor, range: NSRange(location: userQuery.count,length: autocompleteResult.count))
        self.textField?.attributedText = colouredString
    }

    private func moveCaretToEndOfUserQueryPosition(userQuery: String) {
        guard let beginning = textField?.beginningOfDocument else { return }

        if let newPosition = textField?.position(from: beginning, offset: userQuery.count) {
            self.textField?.selectedTextRange = self.textField?.textRange(from: newPosition, to: newPosition)
        }

        if let selectedTextStart = textField?.selectedTextRange?.start {
            textField?.offset(from: beginning, to: selectedTextStart)
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
