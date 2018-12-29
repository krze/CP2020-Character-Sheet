//
//  UsedOnce.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/29/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Used for unique UICollectionViewCells that are only used once but dequeued.
protocol UsedOnce {
    
    var wasSetUp: Bool { get }
    
}
