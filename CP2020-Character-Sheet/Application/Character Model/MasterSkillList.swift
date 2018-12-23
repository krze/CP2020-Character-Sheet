//
//  MasterSkillList.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/22/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

struct MasterSkillList: Codable {
    let allSkills: [Skill]
    
    private enum SkillsKey: CodingKey {
        case allSkills
    }
    
}
