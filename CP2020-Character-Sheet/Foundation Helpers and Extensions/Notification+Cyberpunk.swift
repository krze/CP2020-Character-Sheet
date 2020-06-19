//
//  Notification+Cyberpunk.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/22/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let statsDidChange = Notification.Name("statsDidChange")
    static let roleDidChange = Notification.Name("roleDidChange")
    static let skillDidChange = Notification.Name("skillDidChange")
    static let nameAndHandleDidChange = Notification.Name("nameAndHandleDidChange")
    static let damageDidChange = Notification.Name("damageDidChange")
    static let armorDidChange = Notification.Name("armorDidChange")
    static let saveRollsDidChange = Notification.Name("saveRollsDidChange")
    static let livingStateDidChange = Notification.Name("livingStateDidChange")
    static let humanityDidChange = Notification.Name("humanityDidChange")
    
    static let characterComponentDidRequestSaveToDisk = Notification.Name("characterComponentDidRequestSaveToDisk")
    
    // Show a new view
    static let showHelpTextAlert = Notification.Name("showHelpTextAlert")
    
    // View dismissals
    static let saveWasCalled = Notification.Name("saveWasCalled")
    
    // I/O
    static let saveToDiskRequested = Notification.Name("saveToDiskRequested")

}
