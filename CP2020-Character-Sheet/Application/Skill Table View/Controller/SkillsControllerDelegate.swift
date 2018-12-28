//
//  SkillsControllerDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/27/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol SkillsControllerDelegate: class {
    
    func skillsDidUpdate(skills: [SkillListing])
}
