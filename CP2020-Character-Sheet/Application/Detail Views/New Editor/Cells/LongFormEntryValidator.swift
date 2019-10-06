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
    
    var suggestedMatches = [String]()
    var identifier: Identifier
    var helpText: String
    let isValid = true
    var delegate: UserEntryDelegate?
    
    private let cell: LongFormEntryCollectionViewCell
    private let type: EntryType
    
    init(with cell: LongFormEntryCollectionViewCell, type: EntryType) {
        self.cell = cell
        self.identifier = cell.identifier
        self.helpText = cell.fieldDescription
        self.type = type
        super.init()
        
        self.cell.textView?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveWasCalled), name: .saveWasCalled, object: nil)
    }
    
    func makeFirstResponder() {
        cell.textView?.becomeFirstResponder()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textViewDidEndEditing(_ textField: UITextView) {
        guard let enteredValue = textField.text else { return }
        delegate?.entryDidFinishEditing(identifier: identifier, value: enteredValue, resignLastResponder: resign)
    }
    
    @objc func saveWasCalled() {
        cell.textView?.endEditing(true)
    }
    
    private func resign() {
        cell.textView?.resignFirstResponder()
    }
    
}
