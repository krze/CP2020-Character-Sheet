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
    private var popoverView: PrinterPaperView?
    private let keyboardHiddenOrigin: CGFloat
    private let receiver: EditorValueReciever
    private var userEntryViews = [UserEntryView]()

    private var valuesDidChange = false
    private var currentValues = [Identifier: String]() {
        didSet {
            valuesDidChange = true
        }
    }
    
    private let viewModel: PopoverEditorViewModel
    private weak var activePickerView: DismissablePickerView?
    
    init(with receiver: EditorValueReciever,
         windowFrame: CGRect,
         viewModel: PopoverEditorViewModel) {
        
        popoverFrame = viewModel.adjustedWindowForNumberOfRows(windowFrame)
        keyboardHiddenOrigin = popoverFrame.minY
        
        self.receiver = receiver
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.preferredContentSize = popoverFrame.size
        
        subscribeToKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popoverView = PrinterPaperView(frame: popoverFrame, viewModel: PrinterPaperViewModel())
        // TODO: fill popoverview with User Entry Views using the UserEntryViewCollectionFactory
        view = popoverView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let contentView = popoverView?.contentView else { return }
        let factory = UserEntryViewCollectionFactory(viewModel: viewModel)
        userEntryViews = factory.addUserEntryViews(to: contentView, windowForPicker: view.frame)
        userEntryViews.first(where: { $0.textField != nil })?.textField?.becomeFirstResponder()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.userEntryViews.forEach { userEntryView in
                userEntryView.delegate = self
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        userEntryViews.forEach { entryView in
            entryView.forceEndEdting()
        }
        
        super.viewWillDisappear(animated)
        
        if valuesDidChange {
            receiver.valuesFromEditorDidChange(currentValues)
        }
        
    }
    
    // MARK: UserEntryViewDelegate
    
    func pickerViewWillDisplay(identifier: Identifier, dismissablePickerView: DismissablePickerView) {
        view.addSubview(dismissablePickerView)
        activePickerView = dismissablePickerView
    }
    
    func pickerViewWillClose(identifier: Identifier, dismissablePickerView: DismissablePickerView) {
        activePickerView?.removeFromSuperview()
        
        setLatestValueIfUpdated(for: identifier)
    }
    
    func textFieldDidFinishEditing(identifier: Identifier) {
        setLatestValueIfUpdated(for: identifier)
    }
    
    private func setLatestValueIfUpdated(for identifier: Identifier) {
        guard let value = userEntryViews.first(where: { $0.identifier == identifier })?.userInputValue else {
            return
        }
        
        if currentValues[identifier] != value {
            currentValues[identifier] = value
        }
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
