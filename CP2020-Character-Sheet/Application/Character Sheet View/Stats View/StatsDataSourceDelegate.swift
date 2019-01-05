//
//  StatsDataSourceDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/5/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol StatsDataSourceDelegate: class {
    
    func statsDidUpdate(stats: [Stat: (baseValue: Int, displayValue: Int)])
    
}
