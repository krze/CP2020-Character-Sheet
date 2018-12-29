//
//  ModelManager.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/27/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Manages the loading and storing of models.
final class ModelManager: ModelReceiver {
    
    private(set) var edgerunner: Edgerunner? {
        didSet {
            guard let edgerunner = edgerunner else { return }
            NotificationCenter.default.post(name: .edgerunnerLoaded, object: edgerunner)
            setDelegateControllers(with: edgerunner)
        }
    }
    private(set) var skills: [Skill]?
    private let handler: CharacterSheetFileHandler
    weak var coordinator: CharacterSheetControllerCoordinator?
    
    init(with handler: CharacterSheetFileHandler) {
        self.handler = handler
        self.handler.receiver = self
        
        handler.loadSkills()
        handler.loadEdgerunner()
    }
    
    func edgerunnerLoaded(_ edgerunner: Edgerunner) {
        self.edgerunner = edgerunner
    }
    
    func skillsLoaded(_ skills: [Skill]) {
        self.skills = skills
    }
    
    func edgerunnerFailedToLoad(with error: Error) {
        // TODO: Introduce character creator flow. For now, we're just generating a blank character if there's no edgerunner file.

        if let error = error as? IOError,
            error == .NoSuchFile {
            let stats = Stats(int: 0, ref: 0, tech: 0, cool: 0, attr: 0, luck: 0, ma: 0, body: 0, emp: 0, rep: 0)
            let skills = self.skills ?? [Skill]()
            let edgerunner = Edgerunner(baseStats: stats, role: .Netrunner, humanityCost: 0, skills: skills)
            
            self.edgerunner = edgerunner
            
            return
        }
        print(error)
    }
    
    func skillsFailedToLoad(with error: Error) {
        print(error)
    }
    
    private func setDelegateControllers(with edgerunner: Edgerunner) {
        coordinator?.skillsController = SkillsController(model: edgerunner)
        coordinator?.charaterDescriptionController = CharacterDescriptionController(model: edgerunner)
    }
    
}
