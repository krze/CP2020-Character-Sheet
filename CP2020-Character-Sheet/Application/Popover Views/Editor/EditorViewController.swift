//
//  EditorViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/29/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class EditorViewController: UIViewController, UserEntryViewDelegate, UIPopoverPresentationControllerDelegate, UITextViewDelegate {
    
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
        
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .dark)
        
        // Temporary until dismiss buttons added.
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(close))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTouchesRequired = 1
        blurView.addGestureRecognizer(singleTap)
        
        view.addSubview(blurView)
        
        let popoverView = PrinterPaperView(frame: popoverFrame, viewModel: PrinterPaperViewModel())
        view.addSubview(popoverView)
        
        self.popoverView = popoverView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let contentView = popoverView?.contentView else { return }
        let factory = UserEntryViewCollectionFactory(viewModel: viewModel)
        userEntryViews = factory.addUserEntryViews(to: contentView, windowForPicker: contentView.frame)
        makeNextBlankFieldFirstResponder()
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
    
    // MARK: UITextFieldDelegate
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        makeNextBlankFieldFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let identifier = userEntryViews.first(where: { $0.textField == textField})?.identifier {
            setLatestValueIfUpdated(for: identifier)
        }
    }
    
    // MARK: Private
    
    private func setLatestValueIfUpdated(for identifier: Identifier) {
        guard let value = userEntryViews.first(where: { $0.identifier == identifier })?.userInputValue else {
            return
        }
        
        if currentValues[identifier] != value {
            currentValues[identifier] = value
        }
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    private func subscribeToKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(EditorViewController.keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(EditorViewController.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func makeNextBlankFieldFirstResponder() {
        userEntryViews.first(where: { $0.textField?.text?.isEmpty == true })?.textField?.becomeFirstResponder()
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
    
    // MARK: UIPresentationControllerDelegate
    
    @objc func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}
