//
//  ArmorDamage.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/4/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

struct ArmorDamage: Codable, Hashable {
    let type: ArmorDamageType
    let locations: [BodyLocation]
    let amount: Int
    
    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(locations)
        hasher.combine(amount)
    }

    static func == (lhs: ArmorDamage, rhs: ArmorDamage) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

enum ArmorDamageType: String, Codable {
    case Penetrative, Explosive, Corrosive
}
