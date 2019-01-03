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
    
    var skillsDataSource: SkillsDataSource?
    var characterDescriptionDataSource: CharacterDescriptionDataSource?

    weak var damageModifierDataSource: DamageModifierDataSource?
    
    weak var totalDamageDataSource: TotalDamageDataSource?
    
    weak var highlightedSkillViewCellDataSource: HighlightedSkillViewCellDataSource?
    
    let navigationController: UINavigationController
    let characterSheetViewController: CharacterSheetViewController
    
    private lazy var skillTableViewController: SkillTableViewController? = {
        if let skillsDataSource = skillsDataSource {
            return SkillTableViewController(with: skillsDataSource,
                                            viewModel: SkillTableViewModel(),
                                            tableViewCellModel: SkillTableViewCellModel())
        }
        
        return nil
    }()
    
    private var popoverEditor: EditorViewController?
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(showSkillTable(notification:)), name: .showSkillTable, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showEditor(notification:)), name: .showEditor, object: nil)
    }
    
    @objc private func showSkillTable(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                let skillTableViewController = self.skillTableViewController else {
                return
            }
            
            self.navigationController.pushViewController(skillTableViewController, animated: true)
        }
    }
    
    @objc private func showEditor(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                let constructor = notification.object as? EditorConstructor else {
                    return
            }
            
            let editor = constructor.createEditor(withWindow: self.window.frame)
            
            editor.modalPresentationStyle = .overCurrentContext
            editor.popoverPresentationController?.permittedArrowDirections = .any
            editor.popoverPresentationController?.delegate = editor
            editor.popoverPresentationController?.sourceView = constructor.popoverSourceView
            editor.popoverPresentationController?.sourceRect = constructor.popoverSourceView.bounds
            
            self.popoverEditor = editor
            
            self.navigationController.present(editor, animated: true)
        }

    }
        
    // TODO: Create a method for sending messages between the damage cells and the damage modifier view
    
    // TODO: Create a method for sending messages between the stat view and the skill view
    
}
