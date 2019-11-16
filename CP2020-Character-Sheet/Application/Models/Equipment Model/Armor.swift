//
//  Armor.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/20/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// The class of armor that determines penetrability based on weapon/ammunition type
enum ArmorType: String, Codable {
    case Hard, Soft
}


/// The "Zone" of the body which the armor occupies
enum ArmorZone: Int, CaseIterable, Codable {
    /// Implanted below the skin
    case Subdermal
    
    /// Woven into the skin
    case SkinWeave
    
    /// Attached to the body outside of the skin
    case BodyPlating
    
    /// Completey outside of the body (i.e. a worn kevlar vest)
    case External
    
    var encumbersWhenLayered: Bool {
        switch self {
        case .SkinWeave: return false
        default: return true
        }
    }
}

final class Armor: Codable, Hashable {
    
    let name: String
    let locations: [BodyLocation]
    
    let zone: ArmorZone
    let type: ArmorType
    
    let ev: Int
    
    /// The base SPS that the armor provides when undamaged
    let sps: Int
    
    /// Damage sustained across the whole piece of armor
    var damageSustained: Int = 0
    
    /// The calculated SPS value factoring in damage sustained
    func currentSPS() -> Int {
        return sps - damageSustained
    }
    
    func encumbersWhenLayered() -> Bool {
        return zone.encumbersWhenLayered
    }
    
    /// Creates an armor class
    /// - Parameter type: Classification of armor rigidity
    /// - Parameter sps: Standard Protection
    /// - Parameter ev: Encumberance Value
    /// - Parameter zone: The zone in which the armor occupies inside or outside of the body
    /// - Parameter locations: The locations covered by the single piece of armor
    init(name: String, type: ArmorType, sps: Int, ev: Int, zone: ArmorZone, locations: [BodyLocation]) {
        self.name = name
        self.type = type
        self.sps = sps
        self.ev = ev
        self.zone = zone
        self.locations = locations
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(locations)
        hasher.combine(zone)
        hasher.combine(type)
        hasher.combine(sps)
        hasher.combine(ev)
    }


    static func == (lhs: Armor, rhs: Armor) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

}
