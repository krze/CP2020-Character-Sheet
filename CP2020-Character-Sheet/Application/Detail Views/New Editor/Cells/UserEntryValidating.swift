//
//  UserEntryValidating.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/6/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

protocol UserEntryValidating {
    
    var suggestedMatches: [String] { get set }
    var identifier: Identifier { get }
    var helpText: String { get }
    var isValid: Bool { get }
    
    var delegate: UserEntryDelegate? { get set }
        
    func makeFirstResponder()
    
    func saveWasCalled()
    
}
