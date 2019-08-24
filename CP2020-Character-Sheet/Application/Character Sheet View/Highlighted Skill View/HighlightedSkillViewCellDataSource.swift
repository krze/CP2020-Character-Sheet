//
//  HighlightedSkillViewCellDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/22/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class HighlightedSkillViewCellDataSource {
    
    weak var delegate: SkillsDataSourceDelegate?
    
    private let model: SkillModel
    private var highlightedSkills = [SkillListing]() {
        didSet {
            delegate?.skillsDidUpdate(skills: highlightedSkills)
        }
    }
    
    init(model: SkillModel) {
        self.model = model
    }
    
    func showSkillTable() {
        NotificationCenter.default.post(name: .showSkillTable, object: nil)
    }
    
    /// Synchronously fetches and sorts all skills into highlighted skills.
    func updateHighlightedSkills()  {
        var highlightedSkills = [SkillListing]()
        var allSkills = model.skills.filter { !$0.skill.isSpecialAbility || $0.skill.name == model.role.specialAbility() }
        if let specialAbilityIndex = allSkills.firstIndex(where: { $0.skill.isSpecialAbility }) {
            let specialAbility = allSkills.remove(at: specialAbilityIndex)
            highlightedSkills.append(specialAbility)
        }
        allSkills.sort(by: { $0.skillRollValue > $1.skillRollValue })
        while highlightedSkills.count <= 10 || !highlightedSkills.isEmpty {
            highlightedSkills.append(allSkills.removeFirst())
        }
        
        self.highlightedSkills = highlightedSkills
    }
    
}
