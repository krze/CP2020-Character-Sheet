//
//  SkillsController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Manages the array of skills to display in skill tables and signals the model to update
/// when values have changed
final class SkillsController {
    private let manager: SkillManager
    
    init(manager: SkillManager) {
        self.manager = manager
    }
    
    /// Gets the latest array of SkillListings from the character model
    ///
    /// - Returns: The updated skill listings
    func fetchCharacterSkills() -> [SkillListing] {
        // TODO: Filter stuff like "Language" if you have no points in it. Show "Language" and "Expert" without extensions if you dont have a specific language skill. Show your specific skill if you have points in it and hide the language/expert skills that have no extension
        return manager.skills.filter { !$0.skill.isSpecialAbility || $0.skill.name == manager.role.specialAbility() }
    }
}
