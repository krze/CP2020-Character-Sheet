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
final class CharacterSheetCoordinator: CharacterSheetViewDelegate {
    private let navigationController: UINavigationController
    private let characterSheetViewController: CharacterSheetViewController
    
    
    private lazy var skillTableViewController: SkillTableViewController = {
        return SkillTableViewController()
    }()
    
    init(with navigationController: UINavigationController,
         characterSheetViewController: CharacterSheetViewController) {
        self.navigationController = navigationController
        self.characterSheetViewController = characterSheetViewController
        
        createObservers()
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showSkillTable(notification:)), name: .showSkillTable, object: nil)
    }
    
    @objc private func showSkillTable(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.navigationController.pushViewController(self.skillTableViewController, animated: true)
        }
    }
        
    // TODO: Create a method for sending messages between the damage cells and the damage modifier view
    
    // TODO: Create a method for sending messages between the stat view and the skill view
    
}
