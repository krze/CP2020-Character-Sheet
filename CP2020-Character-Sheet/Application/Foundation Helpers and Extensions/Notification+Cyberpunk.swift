//
//  Notification+Cyberpunk.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/22/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let edgerunnerLoaded = Notification.Name("edgerunnerLoaded")
    static let skillPointsDidChange = Notification.Name("skillPointsDidChange")
    static let statsDidChange = Notification.Name("statsDidChange")
    static let roleDidChange = Notification.Name("roleDidChange")
    static let newSkillAdded = Notification.Name("newSkillAdded")
    static let improvementPointsAdded = Notification.Name("improvementPointsAdded")
    static let skillPointModifierDidChange = Notification.Name("skillPointModifierDidChange")
    static let skillPointStatModifierDidChange = Notification.Name("skillPointStatModifierDidChange")
    static let nameAndHandleDidChange = Notification.Name("nameAndHandleDidChange")
    
    // Popovers
    static let showEditor = Notification.Name("showEditor")
    static let showSkillDetail = Notification.Name("showSkillDetail")
    
    // Navigation
    static let showSkillTable = Notification.Name("showSkillTable")

}
