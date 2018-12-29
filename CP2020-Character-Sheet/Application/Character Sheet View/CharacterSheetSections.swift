//
//  CharacterSheetSections.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Enum for managing the character sheet sections in the collection view.
enum CharacterSheetSections: Int, CaseIterable {
    // This ordering is strict!
    case CharacterDescription, Stats, DamageModifier, Damage, Skill
    
    func cellReuseID() -> String {
        switch self {
        case .Damage:
            return String(describing: DamageViewCell.self)
        case .CharacterDescription:
            return String(describing: RoleDescriptionViewCell.self)
        case .Stats:
            return String(describing: StatsViewCell.self)
        case .DamageModifier:
            return String(describing: DamageModifierViewCell.self)
        case .Skill:
            return String(describing: HighlightedSkillViewCell.self)
        }
    }
    
    func cellHeight() -> CGFloat {
        switch self {
        case .DamageModifier:
            return 80
        case .CharacterDescription:
            return 100
        case .Skill:
            return SkillTableConstants.highlightedSkillViewHeight
        default:
            return 160
        }
    }
}
