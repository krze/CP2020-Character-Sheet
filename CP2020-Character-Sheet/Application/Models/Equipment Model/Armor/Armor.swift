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
        let choices = [[ArmorZone.External.stringValue(), ArmorZone.BodyPlating.stringValue()],
                       [ArmorZone.SkinWeave.stringValue(), ArmorZone.Subdermal.stringValue()]]
        return CheckboxConfig(onlyOneChoiceFrom: choices,
                              selectedState: ArmorZone.External.stringValue())
    }
    
}

/// Armor-related entry fields for the editor
enum ArmorField: String, EntryTypeProvider, CaseIterable {
    
    case Name, SP, ArmorType, EV, Locations, Zone
    
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
        case .SP, .EV:
            return .Integer
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
    
    /// The base SP that the armor provides when undamaged
    let sp: Int
    
    /// A unique ID created to ensure two armors don't get mixed up
    let uniqueID: UUID
    
    private(set) var damages = [ArmorDamage]()
    
    /// Creates an armor class
    /// - Parameter type: Classification of armor rigidity
    /// - Parameter sp: Standard Protection
    /// - Parameter ev: Encumberance Value
    /// - Parameter zone: The zone in which the armor occupies inside or outside of the body
    /// - Parameter locations: The locations covered by the single piece of armor
    init(name: String, type: ArmorType, sp: Int, ev: Int, zone: ArmorZone, locations: [BodyLocation]) {
        self.name = name
        self.type = type
        self.sp = sp
        self.ev = ev
        self.zone = zone
        self.locations = locations
        self.uniqueID = UUID()
    }
    
    /// Indicates that the armor adds an enumberance penalty when layered. This is an innate property
    /// of armor placed in certain zones of the Edgerunner.
    func encumbersWhenLayered() -> Bool {
        return zone.encumbersWhenLayered
    }
    
    /// Returns the current SP for the specified location
    /// - Parameter location: The location
    func currentSP(for location: BodyLocation) -> Int {
        let damageAmount: Int = {
            let damages = self.damages.filter { $0.locations.contains(location)}
            
            return damages.reduce(0, { $0 + $1.amount })
        }()
        
        let finalSP = sp - damageAmount
        
        return finalSP > 0 ? finalSP : 0
    }
    
    /// Applies damage to the specified location
    /// - Parameters:
    ///   - damage: The total damage caused by the attack
    ///   - damageType: The type of damage
    ///   - location: The location affected by the damage
    func applyDamage(totalDamage damage: Int, damageType: DamageType, location: BodyLocation) {
        applyDamage(totalDamage: damage, damageType: damageType, locations: [location])
    }
    
    /// Applies damage to the specified locations
    /// - Parameters:
    ///   - damage: The total damage caused by the attack
    ///   - damageType: The type of damage
    ///   - locations: The locations affected by the damage
    func applyDamage(totalDamage damage: Int, damageType: DamageType, locations: [BodyLocation]) {
        let armorDamage = self.armorDamage(for: damageType, totalDamage: damage, locations: locations)
        damages.append(armorDamage)
    }
    
    /// Indicates whether the Armor is damaged at all
    /// - Parameter armor: The armor to check
    func status() -> ArmorLocationStatus {
        var destroyedLocations = [BodyLocation]()
        var damagedLocations = [BodyLocation]()
        for location in locations {
            let currentSP = self.currentSP(for: location)
            
            if currentSP == 0 {
                destroyedLocations.append(location)
            }
            else if currentSP < sp {
                damagedLocations.append(location)
            }
        }
        
        if destroyedLocations.count == locations.count {
            return .Destroyed
        }
        else if destroyedLocations.count > 0 || damagedLocations.count > 0 {
            return .Damaged
        }
        
        return .Undamaged
    }
    
    private func armorDamage(for damageType: DamageType, totalDamage: Int, locations: [BodyLocation]) -> ArmorDamage {
        let damages = Rules.WornArmor.armorDamage(damageType: damageType, totalDamageAmount: totalDamage)
        return ArmorDamage(type: Rules.WornArmor.armorDamageType(for: damageType),
                           locations: locations,
                           amount: type == .Hard ? damages.hard : damages.soft) // FIXME
    }
    
    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(locations)
        hasher.combine(zone)
        hasher.combine(type)
        hasher.combine(sp)
        hasher.combine(ev)
        hasher.combine(damages)
        hasher.combine(uniqueID)
    }

    static func == (lhs: Armor, rhs: Armor) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

}
