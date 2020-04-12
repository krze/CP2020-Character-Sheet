//
//  Button.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 2/8/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

final class Button: UIButton {
    
    private var highlightedColor: UIColor?
    private(set) var defaultColor: UIColor?
    
    override var isHighlighted: Bool {
        set {
            guard isUserInteractionEnabled else { return }
            super.isHighlighted = newValue
            guard highlightedColor != nil else { return }
            
            if newValue == true  {
                backgroundColor = highlightedColor
            }
            else {
                backgroundColor = defaultColor
            }
            
        }
        get {
            return super.isHighlighted
        }
    }
    
    func setHighlightedColor(_ color: UIColor?) {
        highlightedColor = color
        defaultColor = backgroundColor
    }
    
}
