//
//  Int+Nonnegative.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/4/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

extension Int {
    
    /// Ensures the integer is at least 0
    func zeroFloor() -> Int {
        return self < 0 ? 0 : self
    }
}
