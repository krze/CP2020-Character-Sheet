//
//  HighlightedSkillViewCellDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/22/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class HighlightedSkillViewCellDataSource: EditorValueReciever {
    
    weak var delegate: SkillsDataSourceDelegate?
    
    private let model: SkillModel
    private var highlightedSkills = [SkillListing]() {
        didSet {
            delegate?.skillsDidUpdate(skills: highlightedSkills)
        }
    }
    
    init(model: SkillModel) {
        self.model = model
        NotificationCenter.default.addObserver(self, selector: #selector(updateHighlightedSkills), name: .statsDidChange, object: nil)
    }
    
    func valuesFromEditorDidChange(_ values: [Identifier : AnyHashable], validationCompletion completion: @escaping (ValidatedResult) -> Void) {}
    
    func refreshData() {
        updateHighlightedSkills()
    }
    
    func autofillSuggestion(for identifier: Identifier, value: AnyHashable) -> [Identifier : AnyHashable]? {
        return nil
    }
    
    /// Synchronously fetches and sorts all skills into highlighted skills.
    @objc private func updateHighlightedSkills()  {
        var highlightedSkills = [SkillListing]()
        var allSkills = model.skills.filter { !$0.skill.isSpecialAbility || $0.skill.name == model.role.specialAbility() }
        
        // First, append the special ability
        
        if let specialAbilityIndex = allSkills.firstIndex(where: { $0.skill.isSpecialAbility }) {
            let specialAbility = allSkills.remove(at: specialAbilityIndex)
            highlightedSkills.append(specialAbility)
        }
                
        let starredSkills = allSkills.filter({ $0.starred })
        var mutableStarredSkills = [SkillListing]()
        starredSkills.forEach { skill in
            if let index = allSkills.firstIndex(where: { $0.skill == skill.skill }) {
                mutableStarredSkills.append(allSkills.remove(at: index))
            }
        }
        allSkills.sort(by: { $0.skillRollValue > $1.skillRollValue })
        mutableStarredSkills.sort(by: { $0.skillRollValue > $1.skillRollValue })
        
        while highlightedSkills.count <= 10 || !allSkills.isEmpty {
            if mutableStarredSkills.isEmpty {
                highlightedSkills.append(allSkills.removeFirst())
            }
            else {
                highlightedSkills.append(mutableStarredSkills.removeFirst())
            }
        }
        
        self.highlightedSkills = highlightedSkills
    }
    
}
