//
//  EditorViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/29/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class EditorViewController: UIViewController, UserEntryViewDelegate {

    
    private let popoverFrame: CGRect
    private let keyboardHiddenOrigin: CGFloat
    private let receiver: EditorValueReciever
    private let currentValues = [String]()
    
    init(with receiver: EditorValueReciever,
         windowFrame: CGRect,
         viewModel: PopoverEditorViewModel) {
        
        popoverFrame = viewModel.adjustedWindowForNumberOfRows(windowFrame)
        keyboardHiddenOrigin = popoverFrame.minY
        
        self.receiver = receiver
        super.init(nibName: nil, bundle: nil)
        
        subscribeToKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let popoverView = PrinterPaperView(frame: popoverFrame, viewModel: PrinterPaperViewModel())
        // TODO: fill popoverview with User Entry Views.
        view = popoverView
    }
    
    // MARK: UserEntryViewDelegate
    
    func pickerViewWillDisplay(identifier: String, pickerView: UIPickerView) {
        print("fuck")
    }
    
    func textFieldDidFinishEditing(identifier: String) {
        print("shit")
    }
    
    // MARK: Private
    
    private func subscribeToKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(EditorViewController.keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(EditorViewController.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == keyboardHiddenOrigin {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != keyboardHiddenOrigin {
            self.view.frame.origin.y = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
