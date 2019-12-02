//
//  DamageType.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/28/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

enum DamageType: String, CaseIterable {
    case Normal, AP, HyPen, Explosive, Bladed, Monobladed, Blunt
    
    static func checkboxConfig() -> CheckboxConfig {
        let allCases = DamageType.allCases
        var thisRow = [String]()
        
        var choices = [[String]]()
        allCases.enumerated().forEach { index, type in
            thisRow.append(type.rawValue)
            
            if index % 2 == 0 {
                choices.append(thisRow)
                thisRow = [String]()
            }
        }
        
        if !thisRow.isEmpty {
            choices.append(thisRow)
        }

        return CheckboxConfig(choices: choices,
                              maxChoices: 1,
                              minChoices: 1,
                              selectedStates: [DamageType.Normal.rawValue])
    }
    
}
