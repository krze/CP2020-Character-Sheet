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
    static let locationDescription = "You may optionally specify a location where the damage hit, if the attack is aimed at a specific body part. If you do not select a location, a random location will be rolled."
    static let damageType = "Damage Type"
    static let damageTypeDescription = "The nature of the projectile or weapon that causes the damage. This damage type changes the way damage is distributed to the armor or body. Note that some damage types should affect the entire body (i.e. \(DamageType.Explosive.rawValue) and specifying a location will be ignored if those damage types are selected. Consult the rulebook for more details."
    static let damageTypeNormalDescription = "Normal damage type is reduced by the SP value of the armor in the hit location, and any remaining damage is applied as piercing damage."
    static let damageTypeAPDescription = "Damage from AP (Armor Piercing) rounds is reduced by half of the SP value of the armor in the hit location. Any damage that exceeds the reduced armor value for the location it hits is then reduced by half, and applied as piercing damage."
    static let damageTypeHyPenDescription = "Damage from HyPen (Hyper Penetration) rounds is reduced by half of the SP value of the armor in the hit location. Any remaining damage is applied to the location as piercing damage."
    static let damageTypeExplosiveDescription = "Explosive damage is a concussive force; it ignores location and is applied to the entire body. Half the damage is applied as piercing, and half is applied as blunt. All soft armor takes 2 SP points of damage. All hard armor takes 1/4 of the explosion value as damage. All items with SDP (i.e. Cyberlimbs) takes half of the explosion value as damage."
    static let damageTypeBladedDescription = "Damage from Bladed weapons is reduced by half of the SP value of soft armor in the hit location. Hard armor is fully effective. Any remaining damage is applied to the location as piercing damage."
    static let damageTypeMonoBladedDescription = "Damage from Bladed weapons is reduced by 1/3rd of the SP value of soft armor in the hit location, and half of the SP value of hard armor. Any remaining damage is applied to the location as piercing damage."
    static let damageTypeBluntDescription = "Blunt weapon damage is reduced by the SP value of the armor in the hit location, and any remaining damage is applied as blunt damage."
    static let damageTypeCustomDescription = "Custom damage allows you to specify how much damage the armor and body location takes."
    static let coverSP = "Cover SP"
    static let coverSPDescription = "If you enter a value greater than 0, this SP value will be treated as cover, shielding you from damage."
}
