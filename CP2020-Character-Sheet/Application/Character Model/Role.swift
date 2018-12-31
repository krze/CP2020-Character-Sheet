//
//  Role.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/15/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

enum Role: String, Codable, CaseIterable {
    case Rocker, Solo, Cop, Media, Fixer, Corporate, Nomad, Techie, MedTechie, Netrunner
    
    /// The name of the special ability that belongs to the class
    ///
    /// - Returns: The special ability that belongs to the class
    func specialAbility() -> String {
        guard let ability = SpecialAbilities.ability(for: self) else {
            // This will never return based on the mappings. In the future, this guard
            // will be used to signal that a custom class needs to create its own ability.
            return "No Ability"
        }
        
        return ability
    }
}

/// The canon special abilities for each class.
struct SpecialAbilities {
    private static let mappings: [Role: String] = [
        .Rocker: "Charasmatic Leadership",
        .Solo: "Combat Sense",
        .Cop: "Authority",
        .Media: "Credibility",
        .Fixer: "Streetdeal",
        .Corporate: "Resources",
        .Nomad: "Family",
        .Techie: "Jury Rig",
        .MedTechie: "Medical Tech",
        .Netrunner: "Interface"
    ]
    
    static func ability(for role: Role) -> String? {
        return mappings[role]
    }

}
