//
//  Rules.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 8/22/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

/// A set of rules for ensuring a character is valid.
struct Rules {
    
    typealias CharacterStats = CP2020_Character_Sheet.Stats
    
    static func halvedDown(_ amount: Int) -> Int {
        let amount = Double(amount)
        let result = amount * 0.5
        
        return Int(floor(result))
    }
    
    static func halvedUp(_ amount: Int) -> Int {
        let amount = Double(amount)
        let result = amount * 0.5
        
        return Int(ceil(result))
    }
    
    static func quarteredUp(_ amount: Int) -> Int {
        let amount = Double(amount)
        let result = amount * 0.25
        
        return Int(ceil(result))
    }
    
    static func thirdedDown(_ amount: Int) -> Int {
        let amount = Double(amount)
        let multiplier: Double = 1.0/3.0
        let result = amount * multiplier
        
        return Int(floor(result))
    }
    
    struct WornArmor {
        static let maxLayersPerLocation = 3
        static let maxHardArmorPerLocation = 1
        static let minimumLocationCount = 1
        static let softArmorExplosiveDamage = 2
        static let standardArmorDamage = 1
        
        /// Checks the armor to see if you exceed the maximum number of layers per location
        /// - Parameter armor: The armor that needs inspecting
        static func locationsExceedMaxLayers(_ armor: [Armor]) -> [BodyLocation: Int] {
            var violatingLocations = [BodyLocation: Int]()
            BodyLocation.allCases.forEach { location in
                let armorCount = armor.filter({
                    $0.locations.contains(location)
                }).count
                
                if armorCount > maxLayersPerLocation {
                    violatingLocations[location] = armorCount
                }
            }
            
            return violatingLocations
        }
        
        /// Checks the armor to see if you exceed the maximum number of hard armor per location
        /// - Parameter armor: The armor that needs inspecting
        static func locationExceedsMaxHardArmor(_ armor: [Armor]) -> [BodyLocation: Int] {
            var violatingLocations = [BodyLocation: Int]()
            BodyLocation.allCases.forEach { location in
                let hardCount = armor.filter({
                    $0.locations.contains(location) && $0.type == .Hard
                }).count
                
                if hardCount > maxHardArmorPerLocation {
                    violatingLocations[location] = hardCount
                }
            }
            
            return violatingLocations
        }
        
        static func statModifier(forEV ev: Int) -> StatModifier {
            return StatModifier(stat: .Reflex,
                                amount: ev,
                                source: ArmorStrings.encumberanceValue,
                                description: ArmorStrings.evPenaltyDescription,
                                dismissable: false,
                                damageRelated: false,
                                evRelated: true)
        }
        
        /// New Armor layering rules for the bonus gained by the difference between each layer's value
        /// - Parameter diff: The diff between each layer, as a positive number
        static func spDiffBonus(fromDiff diff: Int) -> Int {
            switch diff {
            case 0...4:
                return 5
            case 5...8:
                return 4
            case 9...14:
                return 3
            case 15...20:
                return 2
            case 21...26:
                return 1
            default:
                return 0
            }
        }
        
        /// Returns the effective SP value of armor, taking in variances of the damage type
        ///   - armorType: The type of Armor that needs to be checked
        ///   - sp: The SP of the armor, after any damage reductions are applied
        ///   - damageType: The incoming damageType
        static func effectiveSPValue(of armorType: ArmorType, sp: Int, damageType: DamageType) -> Int {
            let hard = armorType == .Hard
            
            switch damageType {
            case .Monobladed:
                return hard ? halvedDown(sp) : thirdedDown(sp)
            case .Bladed:
                return hard ? sp : halvedDown(sp)
            case .AP, .HyPen:
                return halvedDown(sp)
            case .Explosive:
                return 0
            default:
                return sp
            }
        }
        
        /// Converts DamageType to ArmorDamageType
        /// - Parameter damageType: The type of damage the armor is about to sustain
        static func armorDamageType(for damageType: DamageType) -> ArmorDamageType {
            switch damageType {
            case .Explosive:
                return .Explosive
            case .Corrosive:
                return .Corrosive
            default:
                return .Penetrative
            }
        }
        
        /// Returns the damage armor would sustain if it was penetrated by the damage specified
        /// - Parameters:
        ///   - damageType: The type of damage
        ///   - totalDamageAmount: The total amount of damage in the attack, before armor reduction
        static func armorDamage(damageType: DamageType, totalDamageAmount: Int) -> (soft: Int, hard: Int) {
            switch damageType {
            case .Explosive:
                return (soft: softArmorExplosiveDamage, hard: quarteredUp(totalDamageAmount))
            case .Corrosive:
                return (soft: totalDamageAmount, hard: totalDamageAmount)
            default:
                return (soft: standardArmorDamage, hard: standardArmorDamage)
            }
        }
        
        static func woundDamageValue(damage: Int, damageType: DamageType) -> Int {
            switch damageType {
            case .AP:
                return halvedUp(damage)
            default:
                return damage
            }
        }
        
    }
    
    struct Skills {
        /// The range of valid points a skill can be contained within
        static let validPointRange = 0...10
        
        /// The range valid points IP can be contained within
        static let validIPPointRange = 0...Int.max
        
        /// The range a valid IP multiplier can be contained within
        static let validMultiplierRange = 1...Int.max
    }
    
    struct Stats {
        /// The range of valid points a stat can be
        static let validPointRange = 1...10
        
        /// Validates humanity loss is a valid amount
        ///
        /// - Parameters:
        ///   - empathy: Base empahty value
        ///   - humanityLoss: The amount of humanity loss
        /// - Returns: True if this is a valid amount of humanity loss
        static func checkHumanityLoss(againstBaseEmpathyValue empathy: Int, humanityLoss: Int) -> Bool {
            let maxHumanity = empathy*10
            
            return maxHumanity - abs(humanityLoss) >= 0
        }
        
    }
    
    struct Damage {
        
        /// The maximum number of points an edgerunner can sustain
        static let maxDamagePoints = 40
        
        /// The number of poins per section in an edgerunner's health track
        static let pointsPerSection = 4
        
        /// The amount of damage, if part of a single wound, that requires an immediate mortal check
        static let mortalWoundThreshold = 8
        static let headWoundMultiplier = 2
        static let immediateMortalWoundLevelModifier = 0
        
        static func wound(forTotalDamage totalDamage: Int) -> WoundType? {
            switch totalDamage {
            case 0: return nil
            case 1...4: return .Light
            case 5...8: return .Serious
            case 9...12: return .Critical
            default: return .Mortal
            }
        }
        
        static func mortalValue(forTotalDamage totalDamage: Int) -> Int? {
            switch totalDamage {
            case 13...16: return 0
            case 17...20: return 1
            case 21...24: return 2
            case 25...28: return 3
            case 29...32: return 4
            case 33...36: return 5
            case 37...40: return 6
            default: return nil
            }
        }
        
        static func stunValue(forTotalDamage totalDamage: Int) -> Int? {
            switch totalDamage {
            case 1...4: return 0
            case 5...8: return 1
            case 9...12: return 2
            case 13...16: return 3
            case 17...20: return 4
            case 21...24: return 5
            case 25...28: return 6
            case 29...32: return 7
            case 33...36: return 8
            case 37...40: return 9
            default: return nil
            }
        }
        
        static func statModifiers(forTotalDamage totalDamage: Int, baseStats: CharacterStats) -> [StatModifier] {
            let source = "Damage"
            switch totalDamage {
            case 5...8:
                return [StatModifier(stat: .Reflex,
                                     amount: -2,
                                     source: source,
                                     description: "Penalty from Serious damgage level",
                                     dismissable: false,
                                     damageRelated: true,
                                     evRelated: false)]
            case 9...12:
                let desc = "Penalty from Critical damage level"
                let refDouble = Double(baseStats.ref)
                let intDouble = Double(baseStats.int)
                let coolDouble = Double(baseStats.cool)
                let multiplier = 0.5
                return [StatModifier(stat: .Reflex,
                                     amount: Int(-(refDouble * multiplier).rounded(.toNearestOrAwayFromZero)),
                                     source: source,
                                     description: desc,
                                     dismissable: false,
                                     damageRelated: true,
                                     evRelated: false),
                        StatModifier(stat: .Intelligence,
                                     amount: Int(-(intDouble * multiplier).rounded(.toNearestOrAwayFromZero)),
                                     source: source,
                                     description: desc,
                                     dismissable: false,
                                     damageRelated: true,
                                     evRelated: false),
                        StatModifier(stat: .Cool,
                                     amount: Int(-(coolDouble * multiplier).rounded(.toNearestOrAwayFromZero)),
                                     source: source,
                                     description: desc,
                                     dismissable: false,
                                     damageRelated: true,
                                     evRelated: false)
                ]
            case 13...40:
                let desc = "Penalty from Mortal damage level"
                let refDouble = Double(baseStats.ref)
                let intDouble = Double(baseStats.int)
                let coolDouble = Double(baseStats.cool)
                let multiplier = 2.0 / 3.0
                return [StatModifier(stat: .Reflex,
                                     amount: Int(-(refDouble * multiplier).rounded(.toNearestOrAwayFromZero)),
                                     source: source,
                                     description: desc,
                                     dismissable: false,
                                     damageRelated: true,
                                     evRelated: false),
                        StatModifier(stat: .Intelligence,
                                     amount: Int(-(intDouble * multiplier).rounded(.toNearestOrAwayFromZero)),
                                     source: source,
                                     description: desc,
                                     dismissable: false,
                                     damageRelated: true,
                                     evRelated: false),
                        StatModifier(stat: .Cool,
                                     amount: Int(-(coolDouble * multiplier).rounded(.toNearestOrAwayFromZero)),
                                     source: source,
                                     description: desc,
                                     dismissable: false,
                                     damageRelated: true,
                                     evRelated: false)
                ]
            default:
                return []
            }
        }
        
        static func traumaTypes(for damageType: DamageType) -> [TraumaType] {
            switch damageType {
            case .Blunt:
                return [.Blunt]
            case .Explosive:
                return [.Blunt, .Piercing]
            case .Corrosive:
                return [.Burn]
            default:
                return [.Piercing]
            }
        }
        
        static func effectiveDamage(of damageType: DamageType, amount damage: Int) -> Int {
            switch damageType {
            case .AP:
                return halvedDown(damage)
            default:
                return damage
            }
        }
        
        static func randomBodyLocation() -> BodyLocation {
            let result = DiceRoll.d10().perform()
            
            switch result {
            case 2...4:
                return .Torso
            case 5:
                return .RightArm
            case 6:
                return .LeftArm
            case 7...8:
                return .RightLeg
            case 9...10:
                return .LeftLeg
            default:
                return .Head
            }
        }
    }
}
