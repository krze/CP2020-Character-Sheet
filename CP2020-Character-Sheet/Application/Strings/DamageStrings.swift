//
//  DamageStrings.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

struct DamageStrings {
    
    static let damage = "Damage"
    static let numberOfHits = "Number of Hits"
    static let numberOfHitsDescription = "The number of hits that hit the target."
    static let damageRollDescription = "The dice roll representing the weapon's damage per attack. Weapons that have a ROF greater than 1 cause this random amount of damage per hit."
    static let damageLocationDescription = "The location where the damage hit. If left blank, this will be random. This is only specified if the attacker aimed at a specific body location. Note that automatic fire cannot aim at a specific location.\n\nThree-round burst is random, unless it's aimed at a specific location, and in that case, only the first round hits the specified location. Please use two separate damage calculations if a three-round burst is aimed at a specific location and more than one bullet hits."
}
