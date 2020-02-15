//
//  CharacterCoordinating.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 2/15/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol CharacterCoordinating: class {
    
    /// Sets up the coordinator with the edgerunner. Reloads all the data with the updated edgerunner
    ///
    /// - Parameter edgerunner: The edgerunner loaded from disk.
    func edgerunnerLoaded(_ edgerunner: Edgerunner)
}
