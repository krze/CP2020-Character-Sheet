//
//  ModelReceiver.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/27/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol ModelReceiver: class {
    
    func edgerunnerLoaded(_ edgerunner: Edgerunner)
    
    func edgerunnerFailedToLoad(with error: Error)
    
    func skillsLoaded(_ skills: [Skill])
    
    func skillsFailedToLoad(with error: Error)

}
