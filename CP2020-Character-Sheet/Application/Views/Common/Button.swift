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
    
    /// Slides in a label over the button from right to left.
    /// - Parameters:
    ///   - title: Title to put over the button
    ///   - labelColor: background color of the label
    ///   - animationDuration: The duration to slide in the new label
    ///   - completionDelay: Async delay to hold until executing the completion
    ///   - completion: The completion block
    func animateOver(withTitle title: String, labelColor: UIColor?, animationDuration: TimeInterval, completionDelay: TimeInterval, completion: (() -> Void)? ) {
        self.clipsToBounds = true
        
        let overlayStartOrigin = CGPoint(x: bounds.origin.x + bounds.width, y: bounds.minY)
        let overlayEndOrigin = bounds.origin
        let overlayStartFrame = CGRect(origin: overlayStartOrigin, size: bounds.size)
        let overlayLabel = UILabel(frame: overlayStartFrame)
        
        overlayLabel.font = StyleConstants.Font.defaultBold
        overlayLabel.textColor = StyleConstants.Color.light
        overlayLabel.textAlignment = .center
        overlayLabel.text = title
        overlayLabel.backgroundColor = labelColor
        
        addSubview(overlayLabel)
        
        UIView.animate(withDuration: animationDuration) {
            overlayLabel.frame.origin = overlayEndOrigin
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + completionDelay) {
            completion?()
        }
    }
    
}
