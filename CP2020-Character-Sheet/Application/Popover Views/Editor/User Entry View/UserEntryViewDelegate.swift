//
//  UserEntryViewDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

protocol UserEntryViewDelegate: UITextFieldDelegate {
    
    func pickerViewWillClose(identifier: Identifier, dismissablePickerView: DismissablePickerView)
    
    func pickerViewWillDisplay(identifier: Identifier, dismissablePickerView: DismissablePickerView)
    
}
