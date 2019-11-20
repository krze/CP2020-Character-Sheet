//
//  Dice.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/19/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

extension Int {
    
    /// Generates a die roll, rolling the dice however many times is the value of the integer,
    /// using the sides specified as the number of sides on the die.
    ///
    /// This is modeled after standard dice notation (i.e. 3D6 is 3.D(6))
    ///
    /// The integer must be a positive, non-zero value. If the integer is 0 or less,
    /// this function will return zero. After all, a 0D20 roll is 0!
    ///
    /// - Parameter sides: The number of sides on the die
    func D(_ sides: Int) -> Int {
        guard self > 0 else { return 0}
        let diceNumber = self
        var total = 0

        for _ in 1...diceNumber {
            total += Int.random(in: 1...sides)
        }
        
        return total
    }
}
