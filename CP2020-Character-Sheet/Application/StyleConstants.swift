//
//  StyleConstants.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/25/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct StyleConstants {
    
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
    }

    
    struct Color {
        static let dark = UIColor(red:0.11, green:0.15, blue:0.19, alpha:1.0)
        static let light = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        static let red = UIColor(red:0.81, green:0.07, blue:0.15, alpha:1.0)
        static let gray = UIColor(red:0.55, green:0.54, blue:0.52, alpha:1.0)
    }

}
