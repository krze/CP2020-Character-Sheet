//
//  CharacterSheetControllerCoordinator.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/22/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Coordinator protocol to store the various controllers of the character sheet. This provides
/// top-down coordinator architecture. Controllers are assigned to this Coordinator via property
/// as the controllers are only created once the cells are created. CollectionViewCells inside of the
/// CharacterSheetViewController collection view own their controllers.
protocol CharacterSheetControllerCoordinator: class {
    
    /// Skills controller that belongs to the SkillTableViewController
    var skillsController: SkillsController? { get set }
    
    /// DamageModifierController that belongs to the DamageModifierViewCell
    var damageModifierController: DamageModifierController? { get set }
    
    /// TotalDamageController that belongs to the DamageViewCell
    var totalDamageController: TotalDamageController? { get set }
    
    /// HighlightedSkillViewCellController that belongs to the HighlightedSkillViewCell
    var highlightedSkillViewCellController: HighlightedSkillViewCellController? { get set }
    
    /// CharacterDescriptionController that belongs to the RoleDescriptionViewCell
    var charaterDescriptionController: CharacterDescriptionController? { get set }
    
}
