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
    private(set) var edgerunner: Edgerunner?
    private(set) var skills: [Skill]?
    private let handler: CharacterSheetFileHandler
    
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
        if let error = error as? IOError, error == .NoSuchFile {
            // TODO: Create new edgerunner
        }
        print(error)
    }
    
    func skillsFailedToLoad(with error: Error) {
        print(error)
    }
    
    
}
