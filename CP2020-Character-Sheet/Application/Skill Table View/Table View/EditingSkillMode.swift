//
//  EditingSkillMode.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/15/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// The modes for editing a skill
///
/// - new: Creating a brand new skill
/// - existing: Editing an existing skill (simple)
/// - existingWithExtension: Editing an existing skill that may already be in the list without an extension
///                          (i.e. Changing 'Expert' to 'Expert: Particle Physics'
enum EditingSkilMode {
    case new, existing, existingWithExtension
}
