//
//  SkillTableSections.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

enum SkillTableSections: Int, CaseIterable {
    case SpecialAbility = 0, Attractiveness, Body, Cool, Empathy, Intelligence, Reflex, Tech
    
    static func section(for stat: Stat) -> SkillTableSections {
        switch stat {
        case .Attractiveness:
            return SkillTableSections.Attractiveness
        case .Body:
            return SkillTableSections.Body
        case .Cool:
            return SkillTableSections.Cool
        case .Empathy:
            return SkillTableSections.Empathy
        case .Intelligence:
            return SkillTableSections.Intelligence
        case .Reflex:
            return SkillTableSections.Reflex
        case .Tech:
            return SkillTableSections.Tech
        default:
            return SkillTableSections.SpecialAbility
        }
    }
    
    func string() -> String {
        switch self {
        case .SpecialAbility:
            return "Special Ability"
        case .Attractiveness:
            return Stat.Attractiveness.rawValue
        case .Body:
            return Stat.Body.rawValue
        case .Cool:
            return Stat.Cool.rawValue
        case .Empathy:
            return Stat.Empathy.rawValue
        case .Intelligence:
            return Stat.Intelligence.rawValue
        case .Reflex:
            return Stat.Reflex.rawValue
        case .Tech:
            return Stat.Tech.rawValue
        }
    }
}
