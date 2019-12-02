//
//  Stats.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/23/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Non-mutable Edgerunner stat points. This struct includes the stats that are assinged during
/// character creation. This does not include calculated stats.
struct Stats: Codable {
    
    /// Intellience
    let int: Int
    
    /// Reflex
    let ref: Int
    
    /// Technical ability
    let tech: Int
    
    /// Cool/Willpower
    let cool: Int
    
    /// Attractiveness
    let attr: Int
    
    /// Luck
    let luck: Int
    
    /// Movement Allowance
    let ma: Int
    
    /// Body
    let body: Int
    
    /// Empathy
    ///
    /// This is the base empathy stat, before humanity loss
    let emp: Int
    
    /// Reputation
    let rep: Int
    
}
