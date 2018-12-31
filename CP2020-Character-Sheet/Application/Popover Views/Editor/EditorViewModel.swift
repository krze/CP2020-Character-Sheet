//
//  EditorViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

protocol EditorViewModel {
    
    /// The number of rows of user entry views to provide
    var numberOfRows: Int { get }
    
    /// Row height of the user entry views
    var minimumRowHeight: CGFloat { get }
    
    /// Returns a frame from the window size that contains just enough space to provide for the editor fields.
    ///
    /// - Parameter window: The entire view space provided for the view
    /// - Returns: CGRect
    func adjustedWindowForNumberOfRows(_ window: CGRect) -> CGRect
}

extension EditorViewModel where Self: PopoverViewFrameProvider {
    
    func adjustedWindowForNumberOfRows(_ window: CGRect) -> CGRect {
        let newFrame = popoverFrameFrom(window: window)
        let necessaryHeight = CGFloat(numberOfRows) * minimumRowHeight
        
        if newFrame.height > necessaryHeight {
            return CGRect(x: newFrame.minX, y: newFrame.minY, width: newFrame.width - 20, height: necessaryHeight)
        }
        
        return newFrame
    }
    
}
