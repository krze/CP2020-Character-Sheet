//
//  Armor.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/20/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// The class of armor that determines penetrability based on weapon/ammunition type
enum ArmorType: String, Codable, CaseIterable, CheckboxConfigProviding {
    
    static func checkboxConfig() -> CheckboxConfig {
        let choices = ArmorType.allCases.map { $0.rawValue }
        return CheckboxConfig(onlyOneChoiceFrom: [choices],
                              selectedState: ArmorType.Soft.rawValue)
    }
    
    case Soft, Hard
}


/// The "Zone" of the body which the armor occupies
enum ArmorZone: Int, CaseIterable, Codable, CheckboxConfigProviding {
    
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
    
    /// Generates an ArmorZone from the string provided. If no match is found,
    /// it's considered external, worn armor.
    ///
    /// - Parameter string: The string you wish to convert to an ArmorZone
    static func zone(from string: String) -> ArmorZone {
        if string == ArmorStrings.bodyPlating {
            return ArmorZone.BodyPlating
        }
        else if string == ArmorStrings.subdermal {
            return ArmorZone.Subdermal
        }
        else if string == ArmorStrings.skinweave {
            return ArmorZone.SkinWeave
        }
        else {
            return ArmorZone.External
        }
    }
    
    private func stringValue() -> String {
        switch self {
        case .BodyPlating: return ArmorStrings.bodyPlating
        case .External: return ArmorStrings.external
        case .SkinWeave: return ArmorStrings.skinweave
        case .Subdermal: return ArmorStrings.subdermal
        }
    }
    
    static func checkboxConfig() -> CheckboxConfig {
        let choices = [[ArmorZone.Subdermal.stringValue(), ArmorZone.SkinWeave.stringValue()],
                       [ArmorZone.BodyPlating.stringValue(), ArmorZone.External.stringValue()]]
        return CheckboxConfig(onlyOneChoiceFrom: choices,
                              selectedState: ArmorZone.External.stringValue())
    }
    
}

/// Armor-related entry fields for the editor
enum ArmorField: String, EntryTypeProvider, CaseIterable {
    
    case Name, ArmorType, Locations, Zone
    
    func identifier() -> Identifier {
        switch self {
        case .ArmorType:
            return ArmorStrings.type
        default:
            return rawValue
        }
    }
    
    func entryType(mode: EditorMode) -> EntryType {
        switch mode {
        case .free:
            return freeEntryMode()
        default:
            return .Static
        }
    }
    
    static func enforcedOrder() -> [String] {
        return ArmorField.allCases.map { $0.identifier() }
    }
    
    private func freeEntryMode() -> EntryType {
        switch self {
        case .Name:
            return .Text
        case .ArmorType:
            let config = CP2020_Character_Sheet.ArmorType.checkboxConfig()
            return .Checkbox(config)
        case .Locations:
            let config = BodyLocation.checkboxConfig()
            return .Checkbox(config)
        case .Zone:
            let config = ArmorZone.checkboxConfig()
            return .Checkbox(config)
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
