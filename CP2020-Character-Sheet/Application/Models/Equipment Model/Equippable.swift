//
//  Equippable.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 5/22/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol Equippable {
    var equipped: Equipped { get }
}

enum Equipped: Int, Codable {
    case equipped, carried, stored
}
