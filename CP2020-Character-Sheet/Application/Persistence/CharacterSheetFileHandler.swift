//
//  CharacterSheetFileHandler.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/27/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Savesa and loads commonly used objects to and from disk
final class CharacterSheetFileHandler {
    private let io = IO()
    private let skillsHandler = JSONFactory<[Skill]>()
    private let edgerunnerHandler = JSONFactory<Edgerunner>()
    
    weak var receiver: ModelReceiver?
    
    /// Loads the Edgerunner from disk and passes it to the receiver
    func loadEdgerunner() {
        io.load(.Edgerunner) { (data, error) in
            sendEdgerunnerToReceiver(with: data, error: error)
        }
    }
    
    /// Loads all the game's skills from disk and passes them to the receiver
    func loadSkills() {
        io.load(.DefaultSkills) { (data, error) in
            sendSkillsToReceiver(with: data, error: error)
        }
    }
    
    func saveEdgerunner(data: Data, completion: (Error?) -> Void) {
        io.save(data, to: .Edgerunner, completion: completion)
    }
    
    private func sendSkillsToReceiver(with data: Data?, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let error = error {
                self.receiver?.skillsFailedToLoad(with: error)
            }
            
            if let data = data, let skills = self.skillsHandler.decode(with: data) {
                self.receiver?.skillsLoaded(skills)
            }
        }
    }
    
    private func sendEdgerunnerToReceiver(with data: Data?, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let error = error {
                self.receiver?.edgerunnerFailedToLoad(with: error)
            }
            
            if let data = data, let edgerunner = self.edgerunnerHandler.decode(with: data) {
                self.receiver?.edgerunnerLoaded(edgerunner)
            }
        }

    }
    
}
