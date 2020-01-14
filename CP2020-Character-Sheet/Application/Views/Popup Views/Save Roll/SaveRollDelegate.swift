//
//  SaveRollDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/14/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol SaveRollDelegate: class {
    
    func rollPerformed(wasSuccessful: Bool)
    
}
