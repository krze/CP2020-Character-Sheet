//
//  EditorViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/29/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// An editor view controller used for popups. In the future, this will need to be adapted to be used for single-view instead of
/// popups, as there are hard-coded functions to dismiss the view when close or confirm buttons are tapped.
///
/// TODO: Deprecate this in favor of the new EditableScrollViewController
final class EditorViewController: UIViewController, UserEntryViewDelegate, UIPopoverPresentationControllerDelegate, UITextViewDelegate {
    
    private let popoverFrame: CGRect
    private var popoverView: PrinterPaperView?
    private let keyboardHiddenOrigin: CGFloat
    private let receiver: EditorValueReciever
    private var userEntryViews = [UserEntryView]()

    private var dismissingWithoutSaving = false
    private var valuesChanged = false
    private var currentValues = [Identifier: String]() {
        didSet {
            valuesChanged = true
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
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(dismissClearingChanges))
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
        var factory = UserEntryViewCollectionFactory(viewModel: viewModel)
        userEntryViews = factory.addUserEntryViews(to: contentView, windowForPicker: contentView.frame)
        
        if viewModel.includeSpaceForButtons,
            let point = factory.buttonBarPoint,
            let height = factory.buttonBarHeight,
            let topAnchor = factory.bottomAnchorForLastRow {
            let size = CGSize(width: contentView.frame.width, height: height)
            let buttonBarFrame = CGRect(origin: point, size: size)
            let buttonBar = EditorViewButtonBar(frame: buttonBarFrame)
            
            contentView.addSubview(buttonBar)
            NSLayoutConstraint.activate([
                buttonBar.widthAnchor.constraint(equalToConstant: size.width),
                buttonBar.heightAnchor.constraint(equalToConstant: size.height),
                buttonBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                buttonBar.topAnchor.constraint(equalTo: topAnchor)
                ])
            
            buttonBar.confirmButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
            buttonBar.dismissButton.addTarget(self, action: #selector(dismissClearingChanges), for: .touchUpInside)
        }

        
        makeNextBlankFieldFirstResponder()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.userEntryViews.forEach { userEntryView in
                userEntryView.delegate = self
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Ensure that editing did end for every view, so that the values get added to currentValues
        userEntryViews.forEach { entryView in
            entryView.forceEndEdting()
        }
        
        super.viewWillDisappear(animated)
        
        if !dismissingWithoutSaving && valuesChanged {
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
    
    /// Uses an identifier to find the view and checks the value against the current stored value. If the value
    /// is different, its new value is stored for passing to the DataSource.
    ///
    /// - Parameter identifier: The identifier for the field that was updated
    private func setLatestValueIfUpdated(for identifier: Identifier) {
        guard let value = userEntryViews.first(where: { $0.identifier == identifier })?.userInputValue else {
            return
        }
        
        if currentValues[identifier] != value {
            currentValues[identifier] = value
        }
    }
    
    @objc private func dismissClearingChanges() {
        dismissingWithoutSaving = true
        dismissView()
    }
    
    /// Dismisses the popover view.
    @objc private func dismissView() {
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
