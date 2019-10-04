//
//  DamageModifierDataSourceDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/26/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol DamageModifierDataSourceDelegate: class {
    
    func bodyTypeDidChange(save: Int, btm: Int)
    
    func damageDidChange(totalDamage: Int)
    
}
