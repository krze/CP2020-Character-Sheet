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
    
    func showSkillTable() {
        NotificationCenter.default.post(name: .showSkillTable, object: nil)
    }
    
    func valuesFromEditorDidChange(_ values: [Identifier : String], validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {}
    
    func refreshData() {
        updateHighlightedSkills()
    }
    
    func autofillSuggestion(for identifier: Identifier, value: String) -> [Identifier : String]? {
        return nil
    }
    
    
    /// Synchronously fetches and sorts all skills into highlighted skills.
    @objc private func updateHighlightedSkills()  {
        var highlightedSkills = [SkillListing]()
        var allSkills = model.skills.filter { !$0.skill.isSpecialAbility || $0.skill.name == model.role.specialAbility() }
        if let specialAbilityIndex = allSkills.firstIndex(where: { $0.skill.isSpecialAbility }) {
            let specialAbility = allSkills.remove(at: specialAbilityIndex)
            highlightedSkills.append(specialAbility)
        }
        allSkills.sort(by: { $0.skillRollValue > $1.skillRollValue })
        while highlightedSkills.count <= 10 || !allSkills.isEmpty {
            highlightedSkills.append(allSkills.removeFirst())
        }
        
        self.highlightedSkills = highlightedSkills
    }
    
}
