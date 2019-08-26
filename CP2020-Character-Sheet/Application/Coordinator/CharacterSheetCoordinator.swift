//
//  CharacterSheetCoordinator.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/15/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A top-down coordinator for passing data along between UICollectionViewCells within the Character Sheet
/// Use this class to listen to NSNotification signals sent from within the cells that need to be passed along
/// to other cells in order to update their views' DataSources.
///
/// The coordinator also handles presenting popovers that do not belong to a specific cell, and to push new
/// full-screen view controllers such as the full skill listing.
///
/// Use this class in the same way you'd use an application coordinator
final class CharacterSheetCoordinator: CharacterSheetDataSourceCoordinator {
    
    var skillsDataSource: SkillsDataSource? {
        didSet {
            if let dataSource = skillsDataSource {
                let highlighted = dataSource.highlightedSkillsDataSource()
                NotificationCenter.default.post(name: .highlightedSkillsDataSourceAvailable, object: highlighted)
            }
        }
    }
    
    var characterDescriptionDataSource: CharacterDescriptionDataSource?

    weak var damageModifierDataSource: DamageModifierDataSource?
    
    weak var totalDamageDataSource: TotalDamageDataSource?
    
    weak var highlightedSkillViewCellDataSource: HighlightedSkillViewCellDataSource?
    
    let navigationController: UINavigationController
    let characterSheetViewController: CharacterSheetViewController
    
    // Child views
    
    private lazy var skillTableViewController: SkillTableViewController? = {
        if let skillsDataSource = skillsDataSource {
            return SkillTableViewController(with: skillsDataSource,
                                            viewModel: SkillTableViewModel(),
                                            tableViewCellModel: SkillTableViewCellModel())
        }
        
        return nil
    }()
    
    /// Check this to prevent multiple view controllers from being presented
    private var childViewIsPresenting: Bool {
        return skillTableViewController != nil && skillTableViewController?.isBeingPresented == true
    }
    
    private let modelManager: ModelManager
    private let window: UIWindow

    init(with layout: UICollectionViewFlowLayout,
         window: UIWindow?,
         fileHandler: CharacterSheetFileHandler = CharacterSheetFileHandler()) {
        guard let window = window else {
            fatalError("Could not get the main window. But the app would crash before this is ever hit.")
        }
        
        self.window = window
        modelManager = ModelManager(with: fileHandler)
        characterSheetViewController = CharacterSheetViewController(collectionViewLayout: layout)
        navigationController = UINavigationController(rootViewController:characterSheetViewController)
        
        characterSheetViewController.coordinator = self
        modelManager.coordinator = self

        createObservers()
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showSkillTable), name: .showSkillTable, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showEditor), name: .showEditor, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showHelpTextAlert), name: .showHelpTextAlert, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveToDiskRequested(notification:)), name: .saveToDiskRequested, object: nil)

    }
    
    @objc private func showSkillTable(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, !self.childViewIsPresenting,
                let skillTableViewController = self.skillTableViewController else {
                return
            }
            
            self.navigationController.pushViewController(skillTableViewController, animated: true)
        }
    }
    
    @objc private func showEditor(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, !self.childViewIsPresenting,
                let editorViewController = notification.object as? EditorCollectionViewController else {
                    return
            }
            
            self.navigationController.pushViewController(editorViewController, animated: true)
        }
    }
    
    @objc private func showHelpTextAlert(notification: Notification) {
        DispatchQueue.main.async {
            guard let alertController = notification.object as? UIAlertController else { return }
            self.display(alert: alertController)
        }
    }
    
    private func display(alert: UIAlertController) {
        DispatchQueue.main.async {
            self.window.rootViewController?.present(alert, animated: true)
        }
    }
    
    @objc private func saveToDiskRequested(notification: Notification) {
        guard let edgerunnerData = notification.object as? Data else { return }
        modelManager.saveEdgerunner(data: edgerunnerData) { error in
            if let error = error {
                let alert = UIAlertController(title: "Unable to save character:", message: error.localizedDescription, preferredStyle: .alert)
                display(alert: alert)
            }
        }
    }
    
    // TODO: Create a method for sending messages between the damage cells and the damage modifier view
    
    // TODO: Create a method for sending messages between the stat view and the skill view
    
}
