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
    static let highlightedSkillsDataSourceAvailable = Notification.Name("highlightedSkillsDataSourceAvailable")
    static let statsDidChange = Notification.Name("statsDidChange")
    static let roleDidChange = Notification.Name("roleDidChange")
    static let skillDidChange = Notification.Name("skillDidChange")
    static let nameAndHandleDidChange = Notification.Name("nameAndHandleDidChange")
    
    // Show a new view
    static let showEditor = Notification.Name("showEditor")
    static let showSkillDetail = Notification.Name("showSkillDetail")
    static let showHelpTextAlert = Notification.Name("showHelpTextAlert")
    
    // View dismissals
    static let saveWasCalled = Notification.Name("saveWasCalled")
    
    // Navigation
    static let showSkillTable = Notification.Name("showSkillTable")
    
    // I/O
    static let saveToDiskRequested = Notification.Name("saveToDiskRequested")

}
