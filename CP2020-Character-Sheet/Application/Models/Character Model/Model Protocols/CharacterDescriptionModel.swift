//
//  CharacterDescriptionModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/29/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol CharacterDescriptionModel {
    
    var name: String { get }
    var handle: String { get }
    var role: Role { get }
    
    func set(name: String, handle: String, validationCompletion completion: @escaping ValidatedCompletion)
    
    func set(role: Role, validationCompletion completion: @escaping ValidatedCompletion)
    
}
