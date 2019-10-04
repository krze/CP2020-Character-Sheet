//
//  DamageCoordinator.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/3/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

final class DamageCoordinator {
    weak var totalDamageDataSource: TotalDamageDataSource?
    weak var damageModifierDataSource: DamageModifierDataSource?
    
    init(totalDamageSource: TotalDamageDataSource, damageModifierSource: DamageModifierDataSource) {
        self.totalDamageDataSource = totalDamageSource
        self.damageModifierDataSource = damageModifierSource
    }
    
}
