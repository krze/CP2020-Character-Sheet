//
//  Edgerunner.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/23/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// The model for the player character
final class Edgerunner: Codable {
    
    /// Immutable player stats. This is maintained by the Edgerunner, and you must
    /// update the stat via
    private(set) var stats: Stats
    
    private var rawHumanity: Int {
        return stats.emp * 10
    }
    
    private var humanityDeficit: Int
    
    /// Retrieves the value for the stat requested
    ///
    /// - Parameter stat: The stat you want
    /// - Returns: The value for the requested stat
    func value(for stat: Stat) -> Int {
        switch stat {
        case .Intelligence:
            return stats.int
        case .Reflex:
            return stats.ref
        case .Tech:
            return stats.tech
        case .Cool:
            return stats.cool
        case .Attractiveness:
            return stats.attr
        case .Luck:
            return stats.luck
        case .MovementAllowance:
            return stats.ma
        case .Body:
            return stats.body
        case .Empathy:
            // TODO: Cyberpsychosis
            let empathy = value(for: .Humanity) / 10
            
            return empathy > 0 ? empathy : 1
        case .Run:
            return stats.ma * 3
        case .Leap:
            return value(for: .Run) / 4
        case .Lift:
            return value(for: .Body) * 40
        case .Reputation:
            return stats.rep
        case .Humanity:
            return rawHumanity - humanityDeficit
        }
    }
    
    
    /// Updates the stats. This should only be called if editing the character.
    /// Stats are supposed to be static.
    ///
    /// - Parameter stats: The updates stats object
    func set(stats: Stats) {
        self.stats = stats
    }
    
    /// Saves the character to disk.
    private func save() {
        // TODO: Persistence object for managing saves
    }
}
