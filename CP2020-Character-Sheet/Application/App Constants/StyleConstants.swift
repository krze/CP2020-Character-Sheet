//
//  StyleConstants.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/25/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Struct containing constants for UI style among the app, in order to maintain a consistent UI
struct StyleConstants {
    
    /// Fonts to use for any element containing text
    struct Font {
        
        /// The default font for most use cases. Use for small labels/blocks of text.
        static let defaultFont = UIFont(name: "AvenirNext-DemiBold", size: 18)
        
        /// The default font with italic styling. Used to bring attention to conditions (i.e. Stun checks in the damage track)
        static let defaultItalic = UIFont(name: "AvenirNext-DemiBoldItalic", size: 18)
        
        /// The default font with bold styling. Used for titles in small labels
        static let defaultBold = UIFont(name: "AvenirNext-Bold", size: 18)
        
        /// A lighter font, suited to denser blocks of text or descriptions
        static let light = UIFont(name: "AvenirNext-Regular", size: 18)
        
        /// A lighter font, suited to denser blocks of text or descriptions, italicized
        static let lightItalic = UIFont(name: "AvenirNext-RegularItalic", size: 18)
        
        static let maximumSize: CGFloat = 20
        
        static let minimumSize: CGFloat = 12
    }

    /// Colors to use for any element requiring color, including black and white
    struct Color {
        
        /// Current palette:
        /// https://coolors.co/060808-c9c0bb-fcfafc-ce050f-003d71
        
        /// A dark color to be used in place of black. Especially for contrasting against light
        static let dark = UIColor(red:0.02, green:0.03, blue:0.03, alpha:1.0)
        
        static let dark90 = Color.dark.lighter(by: 10.0)
        
        /// A light color to be used in place of white. Especially for contrasting against dark
        static let light = UIColor(red:0.99, green:0.98, blue:0.99, alpha:1.0)
        
        /// A shade of gray, used when a third color is needed to contrast dark and light.
        /// Use to convey disabled or unavailable items (if necessary)
        static let gray = UIColor(red:0.79, green:0.75, blue:0.73, alpha:1.0)
        
        /// A shade of blue, used for confirm buttons or positive attention-grabbing elements
        static let blue = UIColor(red:0.00, green:0.24, blue:0.44, alpha:1.0)
        
        /// A shade of red, used for cancel buttons or negative attention-grabbing elements
        static let red = UIColor(red:0.81, green:0.02, blue:0.06, alpha:1.0)
        
        static let green = UIColor(red:0.00, green:0.56, blue:0.07, alpha:1.0)
        
    }
    
    struct Size {
        
        /// The thickness of borders
        static let borderWidth: CGFloat = 2
        
        /// The amount of padding space to provide around text
        static let textPaddingRatio: CGFloat = 0.05
        /// The amount of padding space to add from the edge of screens
        static let edgePaddingRatio: CGFloat = 0.05
        
        /// The percentage of a view's height to take up with a popover
        static let popoverViewHeightRatio: CGFloat = 0.6
        
        /// The percentage of a view's height to take up with padding to provide for a popover
        static let popoverTopPaddingRatio: CGFloat = 0.075
        
        /// The row height for the editor views
        static let editorRowHeight: CGFloat = 44
        
        static func fivePercentInsets(from frame: CGRect) -> NSDirectionalEdgeInsets {
            return NSDirectionalEdgeInsets(top: frame.height * 0.05,
                                           leading: frame.width * 0.05,
                                           bottom: frame.height * 0.05,
                                           trailing: frame.width * 0.05)
        }
        
        /// Corner rounding radius
        static let cornerRadius: CGFloat = 5
    }

}
