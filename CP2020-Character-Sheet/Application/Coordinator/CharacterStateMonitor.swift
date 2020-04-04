//
//  CharacterStateMonitor.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 4/4/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Monitors for changes in character state to create popup views
final class CharacterStateMonitor: ViewCreating {
    private weak var model: LivingStateModel?
    
    weak var viewCoordinator: ViewCoordinating?
    private weak var presentedPopupView: PopupViewController?
    
    init(model: LivingStateModel) {
        self.model = model
        NotificationCenter.default.addObserver(self, selector: #selector(livingStateChanged), name: .livingStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveRollsChanged), name: .saveRollsDidChange, object: nil)
    }
    
    func forceCheckState() {
        if let state = model?.livingState, state != .alive {
            respond(to: state)
        }
        else if let rolls = model?.saveRolls, !rolls.isEmpty {
            showSavePopup(with: rolls)
        }
    }
    
    private func respond(to state: LivingState) {
        if state == .stunned,
            let rolls = model?.saveRolls,
            !rolls.isEmpty {

            showSavePopup(with: rolls)
        }
        else if state.rawValue >= 0 {
            showDeadPopup(with: state)
        }
        else {
            presentedPopupView?.dismiss()
        }
    }
    @objc private func livingStateChanged() {
        guard let state = model?.livingState else { return }
        respond(to: state)
    }
    
    @objc private func saveRollsChanged() {
        guard let rolls = model?.saveRolls, !rolls.isEmpty else { return }
        showSavePopup(with: rolls)
    }
    
    private func saveRollView(with rolls: [SaveRoll]) -> (saveRollView: SaveRollView, printerPaperView: PrinterPaperView) {
        let saveRollViewModel = SaveRollViewModel(rolls: rolls)
        let popupHeight = saveRollViewModel.totalHeight()

        let printerPaperViewModel = PrinterPaperViewModel()
        let printerSize = CGSize(width: UIScreen.main.bounds.width, height: popupHeight)
        let printerFrame = CGRect(origin: .zero, size: printerSize)
        let printerPaperView = PrinterPaperView(frame: printerFrame, viewModel: printerPaperViewModel)
        let saveRollView = SaveRollView(frame: printerPaperView.contentView.frame)
        
        saveRollView.widthAnchor.constraint(equalToConstant: printerPaperView.contentView.frame.width).isActive = true
        saveRollView.heightAnchor.constraint(equalToConstant: printerPaperView.contentView.frame.height).isActive = true
        
        saveRollView.setup(with: saveRollViewModel, livingStateModel: model)
        printerPaperView.addToContentView(saveRollView)
        
        return (saveRollView, printerPaperView)
    }
    
    
    private func showSavePopup(with rolls: [SaveRoll]) {
        DispatchQueue.main.async {
            let views = self.saveRollView(with: rolls)
            
            if let presentedPopupView = self.presentedPopupView {
                presentedPopupView.addNewViewToStack(views.printerPaperView, contentHeight: views.saveRollView.frame.height)
            }
            else {
                let popupViewModel = PopupViewModel(contentHeight: views.saveRollView.frame.height, contentView: views.printerPaperView)
                let popupView = PopupViewController(with: popupViewModel)
                views.saveRollView.dissmiss = popupView.dismiss
                
                self.presentedPopupView = popupView
                self.viewCoordinator?.popupViewNeedsPresentation(popup: popupView)
            }
        }
    }
    
    private func showDeadPopup(with deadState: LivingState) {
        guard deadState.rawValue >= 0 else { return }
        
        print("I'M FUCKIN DEAD!!!")
    }
}
