//
//  CheckboxConfig.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Configuration for the checkbox style of EntryType
struct CheckboxConfig {

    let choices: [String]
    let maxChoices: Int
    let minChoices: Int
    
    init(choices: [String], maxChoices: Int, minChoices: Int){
        self.choices = choices
        self.maxChoices = maxChoices
        self.minChoices = minChoices
    }
    
    init(onlyOneChoiceFrom choices: [String]) {
        self.choices = choices
        maxChoices = 1
        minChoices = 1
    }
    
}

protocol CheckboxConfigProviding {
    
    /// Provides a checkbox EntryType configuration for the type
    static func checkboxConfig() -> CheckboxConfig
    
}
