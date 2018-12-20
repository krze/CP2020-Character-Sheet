//
//  WoundType.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Categories of Wounds.
///
/// - Light: Light wound
/// - Serious: Serious wound
/// - Critical: Critical wound
/// - Mortal: Mortal Wound
enum WoundType: String {
    case Light, Serious, Critical, Mortal
}

extension WoundType: CaseIterable {}

/// Categories of Stun effects.
///
/// - Stun: Stun effect
enum StunType: String {
    case Stun
}

extension StunType: CaseIterable {}
