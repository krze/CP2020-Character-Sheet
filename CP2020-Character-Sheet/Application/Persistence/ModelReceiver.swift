//
//  ModelReceiver.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/27/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Framework for defining the receiver of data from disk
protocol ModelReceiver: class {
    
    /// The edgerunner successfully loaded from disk, and it's being passed on
    ///
    /// - Parameter edgerunner: Here comes the baby
    func edgerunnerLoaded(_ edgerunner: Edgerunner)
    
    /// The edgerunner failed to load
    ///
    /// - Parameter error: Error describing why the edgerunner failed to load
    func edgerunnerFailedToLoad(with error: Error)
    
    /// The skills from successfully loaded from disk, and it's being passed on here
    ///
    /// - Parameter skills: The skills from disk
    func skillsLoaded(_ skills: [Skill])
    
    /// The skills failed to load
    ///
    /// - Parameter error: Error describing why the skills failed to load
    func skillsFailedToLoad(with error: Error)

}
