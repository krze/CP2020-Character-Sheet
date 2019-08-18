//
//  SkillModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol SkillModel {
    
    var role: Role { get }
    var skills: [SkillListing] { get }
    
    func add(skill newSkill: SkillListing)

    func specialAbilityName() -> String
    
    func value(for: Stat?) -> (baseValue: Int, displayValue: Int)
    
}
