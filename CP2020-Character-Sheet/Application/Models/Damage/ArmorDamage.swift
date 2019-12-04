//
//  ArmorDamage.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/4/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

struct ArmorDamage: Codable {
    let type: ArmorDamageType
    let locations: [BodyLocation]
    let softDamage: Int
    let hardDamage: Int
}

enum ArmorDamageType: String, Codable {
    case Penetrative, Explosive, Corrosive
}
