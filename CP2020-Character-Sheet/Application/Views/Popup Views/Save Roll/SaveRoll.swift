//
//  SaveRoll.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/13/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

struct SaveRoll: Codable, Hashable {
    
    let type: SaveRollType
    let target: Int
    let diceRoll: DiceRoll
    
    private let identifier = UUID()
    
    /// Performs a roll against the target number.
    /// Returns true if the roll was successful.
    func resolve() -> Bool {
        return diceRoll.perform() <= target
    }
    
    // MARK: Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type.rawValue)
        hasher.combine(target)
        hasher.combine(diceRoll)
        hasher.combine(identifier)
    }

    static func == (lhs: SaveRoll, rhs: SaveRoll) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
