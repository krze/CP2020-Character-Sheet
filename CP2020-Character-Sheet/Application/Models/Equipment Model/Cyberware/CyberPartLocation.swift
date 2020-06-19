//
//  CyberPartLocation.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 6/19/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Describes a location where a CyberPart can be replace
enum CyberPartLocation: String, CaseIterable, Codable, CheckboxConfigProviding {
    
    case Head, Torso, LeftArm, RightArm, LeftLeg, RightLeg, LeftHand, RightHand, LeftEye, RightEye

    func labelText() -> String {
        switch self {
        case .LeftArm: return "L. Arm"
        case .RightArm: return "R. Arm"
        case .LeftLeg: return "L. Leg"
        case .RightLeg: return "R. Leg"
        case .LeftEye: return "L. Eye"
        case .RightEye: return "R. Eye"
        case .LeftHand: return "L. Hand"
        case .RightHand: return "R. Hand"
        default: return rawValue
        }
    }
    
    func descriptiveText() -> String {
        switch self {
        case .Head, .Torso:
            return rawValue
        case .LeftArm:
            return BodyStrings.leftArm
        case .RightArm:
            return BodyStrings.rightArm
        case .LeftLeg:
            return BodyStrings.leftLeg
        case .RightLeg:
            return BodyStrings.rightLeg
        case .LeftEye:
            return BodyStrings.leftEye
        case .RightEye:
            return BodyStrings.rightEye
        case .LeftHand:
            return BodyStrings.leftHand
        case .RightHand:
            return BodyStrings.rightHand
        }
    }
    
    /// If a CyberPartLocation replaces an entire BodyLocation, this will return its value
    func replacesBodyLocation() -> BodyLocation? {
        return BodyLocation(rawValue: labelText())
    }
    
    /// Returns the corresponding part of the body where the cyberware is installed.
    /// If the part replaces an entire location, it returns that location.
    func containedWithinBodyLocation() -> BodyLocation {
        switch self {
        case .RightEye, .LeftEye:
            return .Head
        case .RightHand:
            return .RightArm
        case .LeftHand:
            return .LeftArm
        default:
            // Shouldn't fall through to the default torso but just in case
            return replacesBodyLocation() ?? .Torso
        }
    }
    
    static func checkboxConfig() -> CheckboxConfig {
        let choices = [[CyberPartLocation.Head.labelText()],
                       [CyberPartLocation.RightEye.labelText(), CyberPartLocation.LeftEye.labelText()],
                       [CyberPartLocation.RightArm.labelText(), CyberPartLocation.Torso.labelText(), CyberPartLocation.LeftArm.labelText()],
                       [CyberPartLocation.RightHand.labelText(), CyberPartLocation.LeftHand.labelText()],
                       [CyberPartLocation.RightLeg.labelText(), CyberPartLocation.LeftLeg.labelText()]]
        return CheckboxConfig(choices: choices,
                              maxChoices: 1,
                              minChoices: 1,
                              selectedStates: [])
    }
    
    static func from(string: String) -> CyberPartLocation? {
        return CyberPartLocation.allCases.first(where: { $0.labelText() == string }) ?? CyberPartLocation(rawValue: string)
    }
    
}
