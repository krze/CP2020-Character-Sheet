//
//  Skill.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/20/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Represeents a skill available to use as a character.
struct Skill: Codable {
    
    /// Name of the skill
    let name: String
    
    /// Description of the skill
    let description: String
    
    /// Whether the skill is a special ability
    let isSpecialAbility: Bool
    
    /// The character Stat associated with the skill
    let linkedStat: String?
    
    /// In the case where a skill's value is added to another skill's value,
    /// (i.e. Combat Sense is added to Awareness/Notice) this field indicates which
    /// skill it is added to. This is a top-down relationship, the modified skill does not know
    /// its modifier.
    let modifiesSkill: String?
    
    /// Returns the Stat object linked to this skill, if any
    ///
    /// - Returns: Stat that is linked to this skill
    func stat() -> Stat? {
        return Stat(rawValue: linkedStat ?? "")
    }
}
