//
//  PopoverViewFrameProvider.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

protocol PopoverViewFrameProvider {
    
    /// The multiplier added to the window Y origin to provide spacing from the top of the view
    var popoverYSpacingRatio: CGFloat { get }
    
    /// The percentage amount of the view the popover takes up
    var popoverHeightRatio: CGFloat { get }
    
    /// Provides a smaller frame for the popover given a view space
    ///
    /// - Parameter frame: The rect that will contain the popover
    func popoverFrameFrom(window frame: CGRect) -> CGRect
    
}

extension PopoverViewFrameProvider {
    
    func popoverFrameFrom(window frame: CGRect) -> CGRect {
        return CGRect(x: frame.minX, y: frame.height * popoverYSpacingRatio, width: frame.width, height: frame.height * popoverHeightRatio)
    }
    
}
