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
/// to other cells in order to update their views.
///
/// The coordinator also handles presenting popovers that do not belong to a specific cell, and to push new
/// full-screen view controllers such as the full skill listing.
///
/// Use this class in the same way you'd use an application coordinator
final class CharacterSheetCoordinator: CharacterSheetControllerCoordinator {
    
    var skillsController: SkillsController?
    var charaterDescriptionController: CharacterDescriptionController?

    weak var damageModifierController: DamageModifierController?
    
    weak var totalDamageController: TotalDamageController?
    
    weak var highlightedSkillViewCellController: HighlightedSkillViewCellController?
    
    let navigationController: UINavigationController
    let characterSheetViewController: CharacterSheetViewController
    
    private lazy var skillTableViewController: SkillTableViewController? = {
        if let skillsController = skillsController {
            return SkillTableViewController(with: skillsController,
                                            viewModel: SkillTableViewModel(),
                                            tableViewCellModel: SkillTableViewCellModel())
        }
        
        return nil
    }()
    
    private let modelManager: ModelManager

    init(with layout: UICollectionViewFlowLayout, fileHandler: CharacterSheetFileHandler = CharacterSheetFileHandler()) {
        modelManager = ModelManager(with: fileHandler)
        characterSheetViewController = CharacterSheetViewController(collectionViewLayout: layout)
        navigationController = UINavigationController(rootViewController:characterSheetViewController)
        
        characterSheetViewController.coordinator = self
        modelManager.coordinator = self

        createObservers()
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showSkillTable(notification:)), name: .showSkillTable, object: nil)
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
        
    // TODO: Create a method for sending messages between the damage cells and the damage modifier view
    
    // TODO: Create a method for sending messages between the stat view and the skill view
    
}
