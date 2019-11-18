//
//  UIView+Borders.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/14/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

extension UIView {
        
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSides sides: [ViewSide], withColor color: CGColor, thickness: CGFloat) {
        sides.forEach { addBorder(toSide: $0, withColor: color, thickness: thickness) }
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height)
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height)
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness)
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
        }
        
        layer.addSublayer(border)
    }
}
