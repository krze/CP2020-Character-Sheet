//
//  ViewCreating.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 2/13/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol ViewCreating: class {
    
    /// The ViewCoordinator responsible for handling the presentation of views
    var viewCoordinator: ViewCoordinating? { get set }
    
}
