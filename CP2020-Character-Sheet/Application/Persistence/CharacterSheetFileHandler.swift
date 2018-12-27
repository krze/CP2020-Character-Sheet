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
    
    private let receiver: ModelReceiver
    
    init(with receiver: ModelReceiver) {
        self.receiver = receiver
    }
    
    func loadEdgerunner() {
        io.load(.Edgerunner) { (data, error) in
            if let data = data {
                sendEdgerunnerToReceiver(with: data)
            }
            
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    private func sendEdgerunnerToReceiver(with data: Data) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let edgerunner = self.edgerunnerHandler.decode(with: data) {
                self.receiver.edgerunnerLoaded(edgerunner)
            }
        }

    }
    
}
