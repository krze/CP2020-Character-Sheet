//
//  EditorCollectionViewModel+SkillListing.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/27/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

enum EditorMode {
    /// A restricted mode that only allows you to edit some fields
    case edit
    /// All fields are free to edit.
    case free
}

extension EditorCollectionViewModel {
    
    /// Sets up an EditorCollectionViewModel for creating a new skill
    ///
    /// - Returns: EditorCollectionViewModel used to initialize a EditorCollectionViewController
    static func modelForBlankSkill() -> EditorCollectionViewModel {
        let blankSkill = SkillListing(skill: Skill.new(), points: 0, modifier: 0, statModifier: 0)
        return model(from: blankSkill, mode: .free)
    }

    /// Sets up an EditorCollectionViewModel for editing an existing skill
    ///
    /// - Parameters:
    ///   - listing: The skill listing to be edited
    ///   - mode: The mode of editing
    /// - Returns: EditorCollectionViewModel used to initialize a EditorCollectionViewController
    static func model(from listing: SkillListing, mode: EditorMode) -> EditorCollectionViewModel {
        var entryTypesForIdentifiers = [Identifier: EntryType]()
        var placeholdersWithIdentifiers = [Identifier: String]()
        var descriptionsWithIdentifiers = [Identifier: String]()
        
        let fields = SkillField.allCases
        
        fields.forEach { field in
            let identifier = field.identifier()
            entryTypesForIdentifiers[identifier] = field.entryType(mode: mode)
            placeholdersWithIdentifiers[identifier] = placeholder(for: field, from: listing)
            descriptionsWithIdentifiers[identifier] = helpText(for: field)
        }
        
        return EditorCollectionViewModel(layout: .editorDefault(),
                                         entryTypesForIdentifiers: entryTypesForIdentifiers,
                                         placeholdersWithIdentifiers: placeholdersWithIdentifiers,
                                         descriptionsWithIdentifiers: descriptionsWithIdentifiers,
                                         enforcedOrder: SkillField.enforcedOrder(),
                                         mode: mode)
    }
    
    private static func helpText(for skillField: SkillField) -> String {
        switch skillField {
        case .Name:
            return SkillStrings.skillNameHelpText
        case .IPMultiplier:
            return SkillStrings.IPMultiplierHelpText
        case .Stat:
            return SkillStrings.associatedStatHelpText
        case .Points:
            return SkillStrings.pointsAssignedHelpText
        case .Modifier:
            return SkillStrings.modifierPointsHelpText
        case .ImprovementPoints:
            return SkillStrings.improvementPointsHelpText
        case .Description:
            return SkillStrings.descriptionHelpText
        case .ModifiesSkill:
            return SkillStrings.modifiesSkillHelpText
        }
    }
    
    private static func placeholder(for skillField: SkillField, from skillListing: SkillListing) -> String {
        switch skillField {
        case .Name:
            return skillListing.displayName()
        case .IPMultiplier:
            return "\(skillListing.skill.IPMultiplier)"
        case .Stat:
            return skillListing.skill.linkedStat?.rawValue ?? ""
        case .ModifiesSkill:
            return skillListing.skill.modifiesSkill ?? ""
        case .Points:
            return "\(skillListing.points)"
        case .Modifier:
            return "\(skillListing.modifier)"
        case .ImprovementPoints:
            return "\(skillListing.improvementPoints)"
        case .Description:
            return skillListing.skill.description
        }
        
    }
    
}
