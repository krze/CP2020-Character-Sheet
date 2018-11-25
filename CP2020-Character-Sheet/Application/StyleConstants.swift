//
//  StyleConstants.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/25/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct StyleConstants {
    
    /// The default font for most use cases. Use for small labels/blocks of text.
    static let defaultFont = UIFont(name: "AvenirNext-DemiBold", size: 18)
    
    /// The default font with italic styling. Used to bring attention to conditions (i.e. Stun checks in the damage track)
    static let defaultItalicFont = UIFont(name: "AvenirNext-DemiBoldItalic", size: 18)
    
    /// The default font with bold styling. Used for titles in small labels
    static let defaultBoldFont = UIFont(name: "AvenirNext-Bold", size: 18)
    
    /// A lighter font, suited to denser blocks of text or descriptions
    static let lightFont = UIFont(name: "AvenirNext-Regular", size: 18)
    
    /// A lighter font, suited to denser blocks of text or descriptions, italicized
    static let lightItalicFont = UIFont(name: "AvenirNext-RegularItalic", size: 18)
}
