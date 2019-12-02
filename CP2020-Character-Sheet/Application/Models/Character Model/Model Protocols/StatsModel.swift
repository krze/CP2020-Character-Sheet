//
//  StatsModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/1/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol StatsModel {
    
    var baseStats: Stats { get }
    
    var humanityLoss: Int { get }
    
    /// Sets the base stat and humanity loss.
    /// NOTE: This will change in the future. Humanity loss will be calulcated by cyberware.
    /// TODO: Once humanity loss is removed from the editor, modify this method
    ///
    /// - Parameters:
    ///   - baseStats: The new stats
    ///   - humanityLoss: The new humanity loss value
    func set(baseStats: Stats, humanityLoss: Int, validationCompletion completion: @escaping (ValidatedEditorResult) -> Void)
    
    /// Value for the stat requested
    ///
    /// - Parameter stat: Stat requested
    /// - Returns: The baseValue and displayValue for the stat
    func value(for stat: Stat?) -> (baseValue: Int, displayValue: Int)
}
