//
//  IncomingDamage.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/2/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

struct IncomingDamage {
    
    /// The DiceRoll model
    let roll: DiceRoll
    
    /// Number of hits. The number of hits determined how many times the roll is rolled
    let numberOfHits: Int
    
    /// The DamageType
    let damageType: DamageType
    
    /// The body location. Nil value means random location
    let hitLocation: BodyLocation?
    
    /// The SP value of cover the Edgerunner is hiding behind
    let coverSP: Int
    
    /// Each dice roll is performed and added to this array, in order.
    let rollResult: [Int]
    
    /// Creates a DiceRoll. When this object is initialied, the roll is performed and is immutable.
    init(roll: DiceRoll, numberOfHits: Int, damageType: DamageType, hitLocation: BodyLocation?, coverSP: Int) {
        self.roll = roll
        self.numberOfHits = numberOfHits
        self.damageType = damageType
        self.hitLocation = hitLocation
        self.coverSP = coverSP
        
        var rollResult = [Int]()
        
        for _ in 1...numberOfHits {
            // Here's where we roll the dice for XDY+N
            rollResult.append(roll.number.D(roll.sides) + roll.modifier)
        }
        
        self.rollResult = rollResult
    }
    
}