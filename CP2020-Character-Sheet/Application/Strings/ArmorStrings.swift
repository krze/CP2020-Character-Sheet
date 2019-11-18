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
    static let SPS = "SPS"
    static let damage = "Damage"
    static let damageAbbreviation = "Dam"
    static let type = "Type"
    
    static let bodyPlating = "Body Plating"
    static let skinweave = "Skinweave"
    static let subdermal = "Subdermal"
    static let external = "External/Worn"
    
    static let armorNameDescription = "The name that identifies the armor"
    static let armorTypeDescription = "The Armor Type is usually Soft (i.e leather, kevlar), or Hard (i.e steel, MetalGear). Hard armor offers more resistance to damage, but usually at a lower mobility cost."
    static let armorZoneDescription = "The zone in which the armor occupies.\n\n\(external) armor is armor you wear on your body, like a helmet, or armor that you hold, like a riot shield.\n\n\(bodyPlating) is rigid armor mounted to the body, but still outside the skin.\n\n\(skinweave) is armor woven into directly into the skin.\n\n\(subdermal) armor is armor implanted under the skin."
    static let armorLocationDescription = "The location(s) that the armor covers. This can be one or more parts of the body in one piece."
    
}
