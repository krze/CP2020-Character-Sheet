//
//  Stat.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/9/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

enum Stat: String {
    case Intelligence, Tech, Cool, Reflex, Attractiveness, Luck, MovementAllowance, Body, Empathy, Run, Leap, Lift, Humanity
    
    /// Indicates whether the stat is calculated or not. i.e. Run
    ///
    /// - Returns: True if the stat is calculated
    func isCalulated() -> Bool {
        switch self {
        case .Run, .Leap, .Lift, .Humanity:
            return true
        default:
            return false
        }
    }
    
    /// Indicates whether the stat can have a +/- state from its base value. i.e. Empathy
    ///
    /// - Returns: True if the stat has a base state
    func hasBaseState() -> Bool {
        switch self {
        case .Empathy, .Reflex:
            return true
        default:
            return false
        }
    }
    
    /// String abbreviation of the stat
    ///
    /// - Returns: String representing the capitalized abbreviation of the stat
    func abbreviation() -> String {
        switch self {
        case .Intelligence:
            return "INT"
        case .Reflex:
            return "REF"
        case .Attractiveness:
            return "ATTR"
        case .MovementAllowance:
            return "MA"
        case .Empathy:
            return "EMP"
        default:
            return rawValue.uppercased()
        }
    }
}

extension Stat: CaseIterable {}
