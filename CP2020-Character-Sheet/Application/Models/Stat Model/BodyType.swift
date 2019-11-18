//
//  BodyType.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/3/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

enum BodyType: String, Codable {
    
    case VeryWeak, Weak, Average, Strong, VeryStrong, SuperHuman
    
    /// Creates a BodyType from the points in Body
    /// - Parameter bodyPointValue: Returns a BodyType
    static func from(bodyPointValue: Int) -> BodyType {
        switch bodyPointValue {
        case 0...2:
            return .VeryWeak
        case 3...4:
            return .Weak
        case 5...7:
            return .Average
        case 8...9:
            return .Strong
        case 10:
            return .VeryStrong
        default:
            return SuperHuman
        }
    }
    
    /// Returns the Body Type Modifier (BTM) for the body type
    func btm() -> Int {
        switch self {
        case .VeryWeak: return 0
        case .Weak: return -1
        case .Average: return -2
        case .Strong: return -3
        case .VeryStrong: return -4
        case .SuperHuman: return -5
        }
    }
    
}
