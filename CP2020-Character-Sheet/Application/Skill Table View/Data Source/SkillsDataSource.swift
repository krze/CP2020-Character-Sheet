//
//  SkillsDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Manages the array of skills to display in skill tables and signals the model to update
/// when values have changed
final class SkillsDataSource: EditorValueReciever {
    
    private let model: SkillModel
    private var allSkills = [SkillListing]()
    private var characterSkills = [SkillListing]() {
        didSet {
            delegate?.skillsDidUpdate(skills: characterSkills)
        }
    }
    
    weak var delegate: SkillsDataSourceDelegate?
    
    init(model: SkillModel) {
        self.model = model
        allSkills = getAllSkills()
        createObservers()
    }
    
    /// Use a string to search skills matching the name or extension
    ///
    /// - Parameter keyword: The query string
    /// - Returns: The skill listed
    func filterSkills(with keyword: String) -> [SkillListing] {
        return getAllSkills().filter { $0.skill.name.contains(keyword) || $0.skill.nameExtension?.contains(keyword) == true }
    }
    
    /// Adds the skill to the model
    ///
    /// - Parameter newSkill: The new skill to add
    func add(skill newSkill: SkillListing, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        model.add(skill: newSkill, validationCompletion: completion)
    }
    
    func refreshData() {
        self.allSkills = getAllSkills()
        getCharacterSkills()
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCharacterSkills(notification:)), name: .skillDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCharacterSkills(notification:)), name: .roleDidChange, object: nil)
    }
    
    @objc private func updateCharacterSkills(notification: Notification) {
        refreshData()
    }
    
    /// Asynchronously returns all skills that are useable by the player, filtering out irrelevent skills
    func getCharacterSkills() {
        DispatchQueue.main.async {
            let skills = self.allSkills.isEmpty ? self.getAllSkills() : self.allSkills
            self.characterSkills = self.filterSkillsWithExtensions(skills)
        }
    }
    
    /// Creates a highlighted skills data source that only reads from the skill model
    ///
    /// - Returns: HighlightedSkillViewCellDataSource
    func highlightedSkillsDataSource() -> HighlightedSkillViewCellDataSource {
        return HighlightedSkillViewCellDataSource(model: model)
    }
    
    /// Synchronously returns all skills
    ///
    /// - Returns: Every skill listing potentially relevent to the player based on the character role.
    private func getAllSkills() -> [SkillListing] {
        return model.skills.filter { !$0.skill.isSpecialAbility || $0.skill.name == model.role.specialAbility() }
    }
    
    /// Accepts an array of skills and reduces it to a listing of skills that show root skills if there's no skill with an
    /// extension tagged, or hides the root skill if you do. i.e. If you have no Language skills, the returned listing will
    /// show "Language" under intelligence skills. However. If you have "Language: Russian", it will show "Language: Russian",
    /// and hide the base "Language" skill.
    ///
    /// - Parameter skills: An array of skills
    /// - Returns: An array of skills with a filter applied to hide/show base skills or skills with extensions
    private func filterSkillsWithExtensions(_ skills: [SkillListing]) -> [SkillListing] {
        var skills = skills
        var unnecessaryRootSkillNames: [String] = skills.filter({ listing in
            if listing.skill.nameExtension != nil {
                // Preserve skills that have points
                if listing.points > 0 {
                    return true
                }
                    // Remove skills that have no points
                else {
                    skills.removeAll(where: { $0.skill == listing.skill })
                }
            }
            return false
        }).map({ $0.skill.name }) // Get an array of the root skills that have specific skills
        
        unnecessaryRootSkillNames = Array(Set(unnecessaryRootSkillNames))
        
        unnecessaryRootSkillNames.forEach { skillName in
            if let index = skills.firstIndex(where: { $0.skill.name == skillName && $0.skill.nameExtension == nil}) {
                skills.remove(at: index)
            }
        }
        
        return skills
    }
    
    func valuesFromEditorDidChange(_ values: [Identifier : String], validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        guard let name = values[SkillField.Name.identifier()],
            let description = values[SkillField.Description.identifier()],
            let IPMultiplierString = values[SkillField.IPMultiplier.identifier()],
            let IPMultiplierInt = Int(IPMultiplierString),
            let pointsString = values[SkillField.Points.identifier()],
            let points = Int(pointsString),
            let modifierString = values[SkillField.Modifier.identifier()],
            let modifier = Int(modifierString) else {
                return
        }
        
        let nameExtension: String? = {
            let ext = values[SkillField.Extension.identifier()]
            return ext?.isEmpty == true ? nil : ext
        }()
        
        let isSpecialAbility = name == model.specialAbilityName()
        let IPMultiplier = IPMultiplierInt > 0 ? IPMultiplierInt : 1
        let linkedStat: Stat? = {
            if let statString = values[SkillField.Stat.identifier()] {
                return Stat(rawValue: statString)
            }
            
            return nil
        }()
        
        let statModifier: Int? = model.value(for: linkedStat).displayValue
        let modifiesSkill: String? = values[SkillField.ModifiesSkill.identifier()]
        let skill = Skill(name: name,
                          nameExtension: nameExtension,
                          description: description,
                          isSpecialAbility: isSpecialAbility,
                          linkedStat: linkedStat,
                          modifiesSkill: modifiesSkill,
                          IPMultiplier: IPMultiplier)
        let skillListing = SkillListing(skill: skill, points: points, modifier: modifier, statModifier: statModifier)
        model.add(skill: skillListing, validationCompletion: completion)
    }
    
}
