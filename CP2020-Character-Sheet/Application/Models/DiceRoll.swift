//
//  DiceRoll.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/30/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Holds a value for a dice roll.
struct DiceRoll: Codable, Hashable {
    
    let number: Int
    let sides: Int
    let modifier: Int?
    
    /// Rolls the dice
    func perform() -> Int {
        return number.D(sides) + (modifier ?? 0)
    }
    
    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(number)
        hasher.combine(sides)
        hasher.combine(modifier)
    }

    static func == (lhs: DiceRoll, rhs: DiceRoll) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    static func d10() -> DiceRoll {
        return DiceRoll(number: 1, sides: 10, modifier: 0)
    }
}
