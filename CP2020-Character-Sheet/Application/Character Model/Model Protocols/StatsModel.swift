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
    
    func set(baseStats: Stats)
    
}
