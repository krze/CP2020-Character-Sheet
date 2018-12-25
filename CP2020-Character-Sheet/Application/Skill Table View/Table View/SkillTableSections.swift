//
//  SkillTableSections.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

enum SkillTableSections: Int, CaseIterable {
    case SpecialAbility = 0, Attractiveness, Body, Cool, Intelligence, Reflex, Tech
    
    static func section(for stat: Stat) -> SkillTableSections {
        switch stat {
        case .Attractiveness:
            return SkillTableSections.Attractiveness
        case .Body:
            return SkillTableSections.Body
        case .Cool:
            return SkillTableSections.Cool
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
}
