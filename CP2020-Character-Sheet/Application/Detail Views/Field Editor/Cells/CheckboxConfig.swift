//
//  CheckboxConfig.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Configuration for the checkbox style of EntryType
struct CheckboxConfig: Hashable {
    
    /// The cell reuse ID for a collectionView.
    static let editorCellReuseID = "CheckboxEntryCell"
    
    /// Multi-level array to arrange choices by rows
    let choices: [[String]]
    let maxChoices: Int
    let minChoices: Int
    let selectedStates: [String]
    
    /// Creates a Checkbox Config
    /// - Parameters:
    ///   - choices: Multi-level array to determine arrangement of rows
    ///   - maxChoices: Maximum number of choices that can be selected
    ///   - minChoices: Minimum amount of choices that must be selected
    ///   - selectedStates: The states that are selected
    init(choices: [[String]], maxChoices: Int, minChoices: Int, selectedStates: [String]) {
        self.choices = choices
        self.maxChoices = maxChoices
        self.minChoices = minChoices
        self.selectedStates = selectedStates
    }
        
    /// Creates a Checkbox Config with only one choice enforced (radio button behavior)
    /// - Parameters:
    ///   - choices: Multi-level array to determine arrangement of rows
    ///   - selectedState: The state that is selected by default
    init(onlyOneChoiceFrom choices: [[String]], selectedState: String) {
        self.choices = choices
        self.selectedStates = [selectedState]
        maxChoices = 1
        minChoices = 1
        
    }
    
    // MARK: Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(choices)
        hasher.combine(maxChoices)
        hasher.combine(minChoices)
        hasher.combine(selectedStates)
    }


    static func == (lhs: CheckboxConfig, rhs: CheckboxConfig) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    
}

protocol CheckboxConfigProviding {
    
    /// Provides a checkbox EntryType configuration for the type
    static func checkboxConfig() -> CheckboxConfig
    
}
