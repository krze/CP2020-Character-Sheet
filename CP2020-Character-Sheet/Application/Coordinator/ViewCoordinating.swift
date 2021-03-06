//
//  ViewCoordinating.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 2/15/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

protocol ViewCoordinating: class {
    
    /// Passes a VC in for presentation to the coordinator in a modal style
    /// - Parameter vc: The View Controller to present
    func viewControllerNeedsPresentation(vc: UIViewController)
    
    /// Passes a PopupViewController for immediate popup, covering the window
    /// - Parameter popup: The PopupViewController to present
    func popupViewNeedsPresentation(popup: PopupViewController)
    
}
