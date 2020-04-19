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
    private weak var presentedPopupView: PopupViewController? {
        didSet {
            if presentedPopupView == nil {
                deadViewPresented = false
            }
        }
    }
    
    private var deadViewPresented = false
    
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
            showPopup(with: saveRollView(with: rolls))
        }
    }
    
    private func respond(to state: LivingState) {
        guard state != .alive else {
            presentedPopupView?.dismiss()
            presentedPopupView = nil
            return
        }
        
        if state == .stunned,
            let rolls = model?.saveRolls,
            !rolls.isEmpty {

            showPopup(with: saveRollView(with: rolls))
        }
        else if state.rawValue >= 0 {
            showDeadPopup(with: model)
        }
    }
    @objc private func livingStateChanged() {
        guard let state = model?.livingState else { return }
        respond(to: state)
    }
    
    @objc private func saveRollsChanged() {
        guard let rolls = model?.saveRolls, !rolls.isEmpty else { return }
        showPopup(with: saveRollView(with: rolls))
    }
    
    private func saveRollView(with rolls: [SaveRoll]) -> (contentView: SaveRollView, printerPaperView: PrinterPaperView) {
        let saveRollViewModel = SaveRollViewModel(rolls: rolls)
        let popupHeight = saveRollViewModel.totalHeight()

        let printerPaperViewModel = PrinterPaperViewModel()
        let minimumSize = CGSize(width: UIScreen.main.bounds.width, height: popupHeight)
        let minimumFrame = CGRect(origin: .zero, size: minimumSize)
        let printerHeight = PrinterPaperView.requiredPaperHeight(minimumFrame: minimumFrame, viewModel: printerPaperViewModel)
        let printerFrame = CGRect(origin: .zero, size: CGSize(width: minimumSize.width, height: printerHeight))
        let printerPaperView = PrinterPaperView(frame: printerFrame, viewModel: printerPaperViewModel)
        let saveRollViewFrame = CGRect(origin: .zero, size: CGSize(width: printerPaperView.contentView.frame.width, height: popupHeight))
        let saveRollView = SaveRollView(frame: saveRollViewFrame)
        
        saveRollView.setup(with: saveRollViewModel, livingStateModel: model)
        printerPaperView.addToContentView(saveRollView)
        
        return (contentView: saveRollView, printerPaperView: printerPaperView)
    }
    
    private func deadView(with model: LivingStateModel, deadViewModel: DeadViewModel) -> (contentView: DeadView, printerPaperView: PrinterPaperView) {
        let printerPaperViewModel = PrinterPaperViewModel()
        let popupHeight = deadViewModel.totalHeight()
        let minimumSize = CGSize(width: UIScreen.main.bounds.width, height: popupHeight)
        let minimumFrame = CGRect(origin: .zero, size: minimumSize)
        let printerHeight = PrinterPaperView.requiredPaperHeight(minimumFrame: minimumFrame, viewModel: printerPaperViewModel)
        let printerFrame = CGRect(origin: .zero, size: CGSize(width: minimumSize.width, height: printerHeight))
        let printerPaperView = PrinterPaperView(frame: printerFrame, viewModel: printerPaperViewModel)
        let deadViewFrame = CGRect(origin: .zero, size: CGSize(width: printerPaperView.contentView.frame.width, height: popupHeight))
        let deadView = DeadView(frame: deadViewFrame, manager: DeadViewManager(model: model))
        
        deadView.setup(with: deadViewModel)
        printerPaperView.addToContentView(deadView)
        
        return (contentView: deadView, printerPaperView: printerPaperView)
    }
    
    
    private func showPopup(with views: (contentView: UIView & PopupViewDismissing, printerPaperView: PrinterPaperView)) {
        DispatchQueue.main.async {
            views.contentView.dismiss = {
                self.presentedPopupView?.dismiss()
                self.presentedPopupView = nil
            }
            
            if let presentedPopupView = self.presentedPopupView {
                presentedPopupView.addNewViewToStack(views.printerPaperView, contentHeight: views.printerPaperView.frame.height)
            }
            else {
                let popupViewModel = PopupViewModel(contentHeight: views.printerPaperView.frame.height, contentView: views.printerPaperView)
                let popupView = PopupViewController(with: popupViewModel)
                self.presentedPopupView = popupView
                self.viewCoordinator?.popupViewNeedsPresentation(popup: popupView)
            }
        }
    }
    
    private func showDeadPopup(with livingStateModel: LivingStateModel?) {
        guard let livingStateModel = livingStateModel, livingStateModel.livingState.rawValue >= 0, !deadViewPresented else { return }
        let views = deadView(with: livingStateModel, deadViewModel: DeadViewModel(state: livingStateModel.livingState))
        
        showPopup(with: views)
        deadViewPresented = true
    }
    
}
