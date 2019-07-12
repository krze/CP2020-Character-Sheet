//
//  Skill.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Represeents a skill available to use as a character.
struct Skill: Codable, Equatable {
    
    /// Name of the skill
    let name: String
    
    /// An optional extension to the displayed name of the Skill. For example, "Language: Russian"
    /// "Language" is the skill's `name`, and "Russian" would be the `nameExtension`.
    let nameExtension: String?
    
    /// Description of the skill
    let description: String
    
    /// Whether the skill is a special ability
    let isSpecialAbility: Bool
    
    /// The character Stat associated with the skill
    let linkedStat: Stat?
    
    /// In the case where a skill's value is added to another skill's value,
    /// (i.e. Combat Sense is added to Awareness/Notice) this field indicates which
    /// skill it is added to. This is a top-down relationship, the modified skill does not know
    /// its modifier.
    let modifiesSkill: String?
    
    /// The Improvement Point multiplier for the skill. Skills without a listed IP multiplier in
    /// the rulebook get a multiplier of 1.
    let IPMultiplier: Int
    
    enum CodingKeys: String, CodingKey {
        case nameExtension = "name_extension"
        case isSpecialAbility = "special_ability"
        case linkedStat = "linked_stat"
        case modifiesSkill = "modifies_skill"
        case IPMultiplier = "ip_multiplier"
        case name, description
    }
    
    static func == (lhs: Skill, rhs: Skill) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description && lhs.linkedStat == rhs.linkedStat
    }
    
    static func new() -> Skill {
        return Skill(name: "", nameExtension: nil, description: "", isSpecialAbility: false, linkedStat: nil, modifiesSkill: nil, IPMultiplier: 0)
    }
}
