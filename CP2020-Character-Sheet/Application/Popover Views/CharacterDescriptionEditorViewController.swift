//
//  CharacterDescriptionEditorViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/29/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class CharacterDescriptionEditorViewController: UIViewController {
    private let popoverFrame: CGRect
    private let keyboardHiddenOrigin: CGFloat
    private let charaterDescriptionController: CharacterDescriptionController
    
    init(with characterDescriptionController: CharacterDescriptionController,
         windowFrame: CGRect,
         viewModel: CharacterDescriptionEditorViewModel = CharacterDescriptionEditorViewModel()) {
        
        popoverFrame = viewModel.adjustedWindowForNumberOfRows(windowFrame)
        keyboardHiddenOrigin = popoverFrame.minY
        
        self.charaterDescriptionController = characterDescriptionController
        super.init(nibName: nil, bundle: nil)
        
        subscribeToKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let popoverView = PrinterPaperView(frame: popoverFrame, viewModel: PrinterPaperViewModel())
        
        view = popoverView
    }
    
    private func subscribeToKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CharacterDescriptionEditorViewController.keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CharacterDescriptionEditorViewController.keyboardWillHide(notification:)),
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
