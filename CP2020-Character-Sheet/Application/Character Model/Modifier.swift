//
//  Modifier.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 9/29/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol Modifying {
    var amount: Int { get }
    var description: String { get }
}


struct StatModifier: Codable, Modifying {
    let stat: Stat
    let amount: Int
    let description: String
}

struct SkillModifier: Codable, Modifying {
    let skill: Skill
    let amount: Int
    let description: String
}
