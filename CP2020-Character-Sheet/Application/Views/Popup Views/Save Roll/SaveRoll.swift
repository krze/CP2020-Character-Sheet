//
//  SaveRoll.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/13/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

struct SaveRoll {
    
    let type: SaveRollType
    let target: Int
    
    /// Performs a roll against the target number.
    /// Returns true if the roll was successful.
    ///
    /// - Parameter diceRoll: Supply a dice roll
    func roll(_ diceRoll: DiceRoll) -> Bool {
        return diceRoll.perform() <= target
    }
    
}
