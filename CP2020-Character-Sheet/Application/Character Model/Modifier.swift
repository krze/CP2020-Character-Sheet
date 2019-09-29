//
//  Modifier.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 9/29/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol Modifying: Codable {
    /// The value of the modifier. Can be negative or positive.
    var amount: Int { get }
    
    /// The source of the modifier. i.e. the name of the equipment or effect giving it to you
    var source: String { get }
    
    /// The description of the modifier
    var description: String { get }
    
    /// Whether the modifier can be arbitrarily dismissed at any time by the user.
    /// Set this qualifier to true if the effect is temporary, i.e. not tied to equipment or injuries
    var dismissable: Bool { get }
}

/// Used to modify a Stat
struct StatModifier: Modifying {
    /// The Stat modified
    let stat: Stat
    let amount: Int
    let source: String
    let description: String
    let dismissable: Bool
    
    /// If this modifier is related to damage taken, set this to true.
    let damageRelated: Bool
}

/// Used to modify a skill
struct SkillModifier: Modifying {
    /// The Skill modified
    let skill: Skill
    let amount: Int
    let source: String
    let description: String
    let dismissable: Bool
}

/// Used as an arbitrary modifier to something that is not represented in the character sheet, and doesn't
/// come from a specific piece of equipment.
struct ArbitraryModifier: Modifying {
    /// Title used to describe the target of the arbitrary modifier
    let title: String
    let amount: Int
    let source: String
    let description: String
    
    /// ArbitraryModifiers are inherently always dismissable since they're arbitrary.
    let dismissable = true
}
