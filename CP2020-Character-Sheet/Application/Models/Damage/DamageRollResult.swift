//
//  DamageRollResult.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/2/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

struct DamageRollResult {
    let locations: [BodyLocation]
    let amount: Int
    let type: DamageType
}
