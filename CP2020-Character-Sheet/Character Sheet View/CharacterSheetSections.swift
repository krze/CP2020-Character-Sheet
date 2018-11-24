//
//  CharacterSheetSections.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Enum for managing the character sheet sections in the collection view.
enum CharacterSheetSections: Int {
    // This ordering is strict!
    case CharacterDescription, Stats, DamageModifier, Damage, Skill
    
    func cellReuseID() -> String {
        switch self {
        case .Damage:
            return String(describing: DamageViewCell.self)
        case .CharacterDescription:
            return String(describing: CharacterDescriptionViewCell.self)
        case .Stats:
            return String(describing: StatsViewCell.self)
        case .DamageModifier:
            return String(describing: DamageModifierViewCell.self)
        case .Skill:
            return String(describing: SkillViewCell.self)
        }
        

    }
}

extension CharacterSheetSections: CaseIterable {}
