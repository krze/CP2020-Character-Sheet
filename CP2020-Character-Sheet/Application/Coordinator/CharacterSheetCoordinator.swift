//
//  CharacterSheetCoordinator.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/15/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A top-down coordinator for setting up various views for the character sheet, and displaying new views that the sheet requests.
/// This class also ensures views get the updated edgerunenr model once it's loaded from disk.
final class CharacterSheetCoordinator: CharacterCoordinating, ViewCoordinating {
    
    private var skillsDataSource: SkillsDataSource? {
        didSet {
            if let dataSource = skillsDataSource {
                characterSheetViewController.highlightedSkillView?.update(dataSource: dataSource)
            }
        }
    }
    
    private var characterDescriptionDataSource: CharacterDescriptionDataSource? {
        didSet {
            if let dataSource = characterDescriptionDataSource {
                characterSheetViewController.roleDescriptionView?.update(dataSource: dataSource)
            }
        }
    }
    
    private var statsDataSource: StatsDataSource? {
        didSet {
            if let dataSource = statsDataSource {
                characterSheetViewController.statsView?.update(with: dataSource)
            }
        }
    }
    
    private var damageModifierDataSource: DamageModifierDataSource? {
        didSet {
            if let dataSource = damageModifierDataSource {
                characterSheetViewController.damageModifierView?.update(dataSource: dataSource)
            }
        }
    }
    
    private var totalDamageDataSource: TotalDamageDataSource? {
        didSet {
            if let dataSource = totalDamageDataSource {
                characterSheetViewController.damageView?.update(dataSource: dataSource)
            }
        }
    }
    
    private var armorDataSource: ArmorDataSource? {
        didSet {
            if let dataSource = armorDataSource {
                characterSheetViewController.armorView?.update(dataSource: dataSource)
            }
        }
    }
    
    let navigationController: UINavigationController
    let characterSheetViewController: CharacterSheetViewController
    
    // Child views
    
    private var topVC: UIViewController {
        if var topController = window.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }
        
        return navigationController
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
        
        modelManager.coordinator = self
        characterSheetViewController.viewCoordinator = self

        createObservers()
    }
    
    
    // MARK: - CharacterCoordinating
    
    func edgerunnerLoaded(_ edgerunner: Edgerunner) {
        skillsDataSource = SkillsDataSource(model: edgerunner)
        statsDataSource = StatsDataSource(statsModel: edgerunner)
        characterDescriptionDataSource = CharacterDescriptionDataSource(model: edgerunner)
        totalDamageDataSource = TotalDamageDataSource(model: edgerunner)
        damageModifierDataSource = DamageModifierDataSource(model: edgerunner)
        armorDataSource = ArmorDataSource(model: edgerunner)
        refreshCharacterSheet()
    }
    
    // MARK: - ViewCoordinating
    
    func viewControllerNeedsPresentation(vc: UIViewController) {
        let modalView = UINavigationController(rootViewController: vc)
        topVC.present(modalView, animated: true)
    }
    
    func popupViewNeedsPresentation(popup: PopupViewController) {
        popup.modalPresentationStyle = .overFullScreen
        topVC.present(popup, animated: true)
    }
    
    // MARK: - Private
    
    private func display(alert: UIAlertController) {
        DispatchQueue.main.async {
            self.topVC.present(alert, animated: true)
        }
    }
    
    @objc private func showHelpTextAlert(notification: Notification) {
        DispatchQueue.main.async {
            guard let alertController = notification.object as? UIAlertController else { return }
            self.display(alert: alertController)
        }
    }
    
    @objc private func saveToDiskRequested(notification: Notification) {
        guard let edgerunnerData = notification.object as? Data else { return }
        modelManager.saveEdgerunner(data: edgerunnerData) { error in
            if let error = error {
                let alert = UIAlertController(title: "Unable to save character:", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: AlertViewStrings.dismissButtonTitle, style: .default, handler: nil))
                display(alert: alert)
            }
        }
    }
    
    private func refreshCharacterSheet() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.characterSheetViewController.collectionView.reloadData()
        }
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showHelpTextAlert), name: .showHelpTextAlert, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveToDiskRequested(notification:)), name: .saveToDiskRequested, object: nil)
    }
    
}
