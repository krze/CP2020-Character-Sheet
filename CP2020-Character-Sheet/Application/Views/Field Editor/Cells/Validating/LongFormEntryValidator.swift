//
//  LongFormEntryValidator.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/6/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class LongFormEntryValidator: NSObject, UserEntryValidating, UITextViewDelegate {
    
    // MARK: UserEntryValidating
    
    let suggestedMatches: [String]
    var identifier: Identifier
    let isValid = true
    var currentValue: AnyHashable? {
        return cell?.textView?.text
    }
    
    weak var delegate: UserEntryDelegate?
    
    private var cell: LongFormEntryCollectionViewCell?
    private let type: EntryType
    
    init(identifier: Identifier, type: EntryType, suggestedMatches: [String] = [String]()) {
        self.identifier = identifier
        self.type = type
        self.suggestedMatches = suggestedMatches
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveWasCalled), name: .saveWasCalled, object: nil)
    }
    
    func add(cell: LongFormEntryCollectionViewCell) {
        self.cell = cell
        self.cell?.textView?.delegate = self
    }
    
    func makeFirstResponder() -> Bool {
        cell?.textView?.becomeFirstResponder()
        return true
    }
    
    func replaceWithSuggestedMatch(_ value: AnyHashable) {
        resign()
        cell?.textView?.text = value as? String
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.userBeganEditing()
    }
    
    func textViewDidEndEditing(_ textField: UITextView) {
        guard let enteredValue = textField.text else { return }
        delegate?.entryDidFinishEditing(identifier: identifier, value: enteredValue, shouldGetSuggestion: false, resignLastResponder: resign)
    }
    
    @objc func saveWasCalled() {
        cell?.textView?.endEditing(true)
    }
    
    private func resign() {
        cell?.textView?.resignFirstResponder()
    }
    
    /// LongFormEntry views are not validated, so this does nothing
    func forceWarning() {}
    
}
