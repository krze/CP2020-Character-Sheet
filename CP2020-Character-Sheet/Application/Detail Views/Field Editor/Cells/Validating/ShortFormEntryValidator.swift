//
//  ShortFormEntryValidator.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/6/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class ShortFormEntryValidator: NSObject, UserEntryValidating, UITextFieldDelegate {

    // MARK: UserEntryValidating
    
    let suggestedMatches: [String]
    let identifier: Identifier
    private(set) var isValid: Bool = true
    var currentValue: AnyHashable? {
        return cell.textField?.text
    }
    
    weak var delegate: UserEntryDelegate?
    
    private let cell: ShortFormEntryCollectionViewCell
    private let type: EntryType
    private var needsValidation: Bool = false
    
    // Suggested Match Logic
    
    private var autoCompleteCharacterCount = 0
    private var timer = Timer()
    private var partialMatch: String?
    
    /// Use this as a one-way read for the done button to ensure it's only ever true once
    private var doneButtonPressed: Bool {
        set {
            consumedDoneButtonState = newValue
        }
        get {
            let doneButtonState = consumedDoneButtonState
            consumedDoneButtonState = false
            return doneButtonState
        }
    }
    
    private var consumedDoneButtonState = false
    
    init(with cell: ShortFormEntryCollectionViewCell, type: EntryType, suggestedMatches: [String] = [String]()) {
        self.cell = cell
        self.identifier = cell.identifier
        self.type = type
        self.suggestedMatches = suggestedMatches
        super.init()
        
        self.cell.textField?.delegate = self
        setupForType()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveWasCalled), name: .saveWasCalled, object: nil)
    }
    
    private func setupForType() {
        switch type {
        case .Static:
            cell.textField?.isUserInteractionEnabled = false
            cell.contentView.backgroundColor = StyleConstants.Color.gray
            cell.textField?.backgroundColor = StyleConstants.Color.gray
        case .Integer:
            cell.textField?.keyboardType = .numberPad
            cell.textField?.addDoneButtonOnKeyboard()
            fallthrough
        case .EnforcedChoiceText(_):
            if let existingValue = cell.textField?.text {
                validate(userEntry: existingValue)
            }
            needsValidation = true
        default: return
        }
    }
    
    // MARK: UserEntryValidating
    
    func makeFirstResponder() -> Bool {
        cell.textField?.becomeFirstResponder()
        return true
    }
    
    @objc func saveWasCalled() {
        if cell.textField?.isEditing == true {
            cell.textField?.endEditing(true)
        }
    }
    
    func replaceWithSuggestedMatch(_ value: AnyHashable) {
        guard let value = value as? String else { return }
        cell.textField?.text = value
        validate(userEntry: value)
    }
    
    func forceWarning() {
        showPopup()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneButtonPressed = true
        processAccepted(textField)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        processAccepted(textField)
    }
    
    func processAccepted(_ textField: UITextField) {
        guard autofills() else {
            self.processEntry(textField)
            return
        }
        
        if doneButtonPressed {
            if let potentialMatch = textField.attributedText?.string {
                textField.attributedText = nil
                textField.text = isEnforced() ? suggestedMatches.first(where: { $0.lowercased() == potentialMatch.lowercased() }) : potentialMatch
                textField.textColor = StyleConstants.Color.dark
            }
        }
        else if let partialMatch = partialMatch,
            let existingText = textField.text {
            textField.attributedText = nil
            textField.textColor = StyleConstants.Color.dark
            textField.text = partialMatch.count > existingText.count ? partialMatch : suggestedMatches.first(where: { $0.lowercased() == existingText.lowercased() })
        }
        
        self.processEntry(textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideWarning()
        delegate?.userBeganEditing()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard autofills() else { return true }
        // Backspace detection
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92), let text = textField.text {
                let location = range.location
                let endLocation = text.count - 1
                var suggestedTextPresent = false
                
                textField.attributedText?.enumerateAttribute(.foregroundColor, in: NSRange(0..<text.count)) { value, range, stop in
                    if value as? UIColor == StyleConstants.Color.gray {
                        suggestedTextPresent = true
                    }
                }
                
                // Check if the deletion is happening in the middle of the string with a suggestion at the end.
                // If so, this block will clear the attributed text at the end of the string
                if location < endLocation && suggestedTextPresent {
                    let trimmedText = text.prefix(location + 1)
                    textField.attributedText = nil
                    textField.text = String(trimmedText)
                }
                
                autoCompleteCharacterCount = 0
                return true
            }
        }

        guard let text = textField.text as NSString? else { return false }
        let subString = format(subString: text.replacingCharacters(in: range, with: string))
        
        if subString.isEmpty {
            resetValues()
        } else {
            searchAutocompleteEntries(with: subString)
        }
        return true
    }
    
    // MARK: Private - Autofill Methods

    private func format(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount))
        return formatted
    }

    private func resetValues() {
        autoCompleteCharacterCount = 0
        partialMatch = nil
    }

    private func searchAutocompleteEntries(with userQuery: String) {
        let suggestions = autocompleteSuggestions(for: userQuery)

        if suggestions.count > 0 {
            partialMatch = userQuery
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                let autocompleteResult = self.formatAutocompleteResult(substring: userQuery, possibleMatches: suggestions)
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery: userQuery)
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery)
            })
        } else {
            partialMatch = nil
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                self.cell.textField?.text = userQuery
            })
            autoCompleteCharacterCount = 0
        }
    }

    private func autocompleteSuggestions(for userText: String) -> [String]{
        return suggestedMatches.filter({ suggestedMatch in
            if let range = suggestedMatch.lowercased().range(of: userText.lowercased()) {
                return range.lowerBound == suggestedMatch.startIndex
            }

            return false
        })
    }

    private func putColourFormattedTextInTextField(autocompleteResult: String, userQuery: String) {
        let styledString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        styledString.addAttribute(.foregroundColor, value: StyleConstants.Color.gray, range: NSRange(location: userQuery.count,length: autocompleteResult.count))
        cell.textField?.attributedText = styledString
    }

    private func moveCaretToEndOfUserQueryPosition(userQuery: String) {
        guard let beginning = cell.textField?.beginningOfDocument else { return }

        if let newPosition = cell.textField?.position(from: beginning, offset: userQuery.count) {
            cell.textField?.selectedTextRange = cell.textField?.textRange(from: newPosition, to: newPosition)
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
    
    private func autofills() -> Bool {
        switch type {
        case .SuggestedText(_), .EnforcedChoiceText(_):
            return true
        default:
            return false
        }
    }
    
    private func suggestsCompletion() -> Bool {
        switch type {
        case .SuggestedText(_):
            return true
        default:
            return false
        }
    }
    
    // MARK: Private - Enforced Entry Logic
    
    private func isEnforced() -> Bool {
        switch type {
        case .EnforcedChoiceText(_): return true
        default: return false
        }
    }
    
    private func showPopup() {
        guard let userEntry = cell.textField?.text else { return }
        var choices = ""

        suggestedMatches.enumerated().forEach { index, choice in
            choices.append(contentsOf: choice)

            if suggestedMatches[index] != suggestedMatches.last {
                choices.append(contentsOf: ", ")
            }
        }
        let title = userEntry.count > 0 ? "\(userEntry) is an invalid choice" : "\(identifier) cannot be blank."
        let alert = UIAlertController(title: title, message: "Please select one of the following:\n\(choices)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertViewStrings.dismissButtonTitle, style: .default, handler: nil))
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }
    
    // MARK: Private - Common
    
    private func processEntry(_ textField: UITextField) {
        guard let userEntry = textField.text else { return }
        
        if needsValidation {
            validate(userEntry: userEntry)
        }
        
        if !isEnforced() || isEnforced() && isValid {
            delegate?.entryDidFinishEditing(identifier: identifier, value: userEntry, shouldGetSuggestion: suggestsCompletion(), resignLastResponder: resign)
            resetValues()
        }
        else {
             showPopup()
        }
        
    }
    
    private func resign() {
         cell.textField?.resignFirstResponder()
    }
     
    private func showWarning() {
         cell.textField?.backgroundColor = StyleConstants.Color.red.withAlphaComponent(0.5)
    }

    private func hideWarning() {
         cell.textField?.backgroundColor = StyleConstants.Color.light
    }
     
    private func validate(userEntry: String) {
        switch type {
        case .Integer:
            guard !userEntry.isEmpty && Int(userEntry) != nil else {
                isValid = false
                showWarning()
                return
            }
                isValid = true
                hideWarning()
        case .EnforcedChoiceText(_):
            guard !suggestedMatches.isEmpty else { return }
            if suggestedMatches.contains(userEntry) {
                isValid = true
                hideWarning()
            }
            else {
                isValid = false
                showWarning()
            }
        default:
            return
        }
    }

}
