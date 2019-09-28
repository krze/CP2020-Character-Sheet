//
//  CharacterSheetDataSourceCoordinator.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/22/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Coordinator protocol to store the various data sources of the character sheet. This provides
/// top-down coordinator architecture. Data sources are assigned to this Coordinator via property
/// as the controllers are only created once the cells are created. CollectionViewCells inside of the
/// CharacterSheetViewController collection view own their data sources.
protocol CharacterSheetDataSourceCoordinator: class {
    
    /// Skills controller that belongs to the SkillTableViewController
    var skillsDataSource: SkillsDataSource? { get set }
    
    /// DamageModifierController that belongs to the DamageModifierViewCell
    var damageModifierDataSource: DamageModifierDataSource? { get set }
    
    /// TotalDamageController that belongs to the DamageViewCell
    var totalDamageDataSource: TotalDamageDataSource? { get set }
    
    /// CharacterDescriptionController that belongs to the RoleDescriptionViewCell
    var characterDescriptionDataSource: CharacterDescriptionDataSource? { get set }
    
}
