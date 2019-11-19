//
//  ArmorStrings.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

struct ArmorStrings {
    
    static let armorName = "Armor Name"
    static let SP = "SP"
    static let EV = "EV"
    static let encumberanceValue = "Encumberance Value"
    static let damage = "Damage"
    static let damageAbbreviation = "Dam"
    static let type = "Type"
    
    static let bodyPlating = "Body Plating"
    static let skinweave = "SkinWeave"
    static let subdermal = "Subdermal"
    static let external = "External/Worn"
    
    static let armorNameDescription = "The name that identifies the armor"
    static let spDescription = "'SP' is short for Standard Protection. This is the amount of damage the armor negates. This should be entered as a positive number."
    static let armorTypeDescription = "Armor Type is either 'Hard' or 'Soft'. Soft armor is pliable, akin to materials like leather and kevlar. Hard armor is rigid, like steel or 'MetalGear'. Hard armor offers more resistance to damage, but usually comes with an EV penalty."
    static let evDescription = "'EV' is short for \(encumberanceValue). EV reduces your Reflex (REF) by the same value. This entered value is an inherent penalty that comes with this particular piece of armor, and is separate from the EV penalty that comes from layering armor. \n\nAlthough this value is a penalty against REF, it should be entered as a positive number.\n\nNote that in some cases, armor comes with an EV 'bonus'. This is not supported here yet. For such cases, give your character a REF bonus modifier and set this value to 0."
    static let armorZoneDescription = "The zone in which the armor occupies.\n\n\(external) armor is armor you wear on your body, like a helmet, or armor that you hold, like a riot shield.\n\n\(bodyPlating) is rigid armor mounted to the body, but still outside the skin.\n\n\(skinweave) is armor woven into directly into the skin.\n\n\(subdermal) armor is armor implanted under the skin."
    static let armorLocationDescription = "The location(s) that the armor covers. This can be one or more parts of the body in one piece."
    
    static let evPenaltyDescription = "Penalty incurred from worn armor. A combination of both the sum of all armor pieces' inherent EV, and the penalty from layered armor."
    
}
