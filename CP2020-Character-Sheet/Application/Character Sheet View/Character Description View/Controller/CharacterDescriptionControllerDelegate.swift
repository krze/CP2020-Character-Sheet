//
//  CharacterDescriptionControllerDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/29/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol CharacterDescriptionControllerDelegate {
    
    func update(name: String, handle: String)
    
    func update(role: Role)
    
}
