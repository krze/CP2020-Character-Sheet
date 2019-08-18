//
//  SkillField.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/20/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

enum SkillField: String, EntryTypeProvider, CaseIterable {
    private typealias CharacterStat = Stat
    case Name, Extension, IPMultiplier, Stat, Points, Modifier, ImprovementPoints, Description, ModifiesSkill
    
    
    func identifier() -> Identifier {
        switch self {
        case .ImprovementPoints:
            return SkillStrings.improvementPoints
        case .IPMultiplier:
            return SkillStrings.IPMultiplier
        case .ModifiesSkill:
            return SkillStrings.modifiesSkill
        default:
            return rawValue
        }
    }
    
    func entryType(mode: EditorMode) -> EntryType {
        switch mode {
        case .free:
            return freeEntryType()
        case .edit:
            return editingEntryType()
        }
    }
    
    private func freeEntryType() -> EntryType {
        switch self {
        case .Name, .Extension, .ModifiesSkill:
            return .Text
        case .Points, .Modifier, .ImprovementPoints, .IPMultiplier:
            return .Integer
        case .Description:
            return .LongFormText
        case .Stat:
            var stats = CharacterStat.linkedStats().map { $0.rawValue }
            stats.append("None")
            
            return .EnforcedChoiceText(stats)
        }
    }
    
    private func editingEntryType() -> EntryType {
        switch self {
        case .Points, .Modifier, .ImprovementPoints:
            return .Integer
        case .Extension:
            return .Text
        case .Description:
            return .LongFormText
        default:
            return .Static
        }
    }
    
    static func enforcedOrder() -> [String] {
        return allCases.map { $0.identifier() }
    }
    
}
