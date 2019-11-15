//
//  ArmorDataSourceDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by iKreb Retina on 11/10/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol ArmorDataSourceDelegate: class {

    func armorDidChange(locationSPS: [BodyLocation: Int])

}

