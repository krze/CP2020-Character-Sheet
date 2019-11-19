//
//  BodyPartView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/16/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit


protocol BodyPartStatus {
    
    func color() -> UIColor
}

enum ArmorLocationStatus: BodyPartStatus {
    case Undamaged, Damaged
    
    func color() -> UIColor {
        switch self {
        case .Damaged: return StyleConstants.Color.red
        case .Undamaged: return StyleConstants.Color.dark
        }
    }
}


protocol BodyPartView: UIView {
    
    /// The location as a type
    var location: BodyLocation { get }
    
    /// An optional status view that describes the condition of the body part
    var descriptionView: UIView? { get }
    
    /// Sets the status for the body part
    /// - Parameter status: The new body part status
    func setStatus(_ status: BodyPartStatus)
    
    /// Adds the given description view to the view.
    /// - Parameter view: View to add
    func addDescriptionView(_ view: UIView)
    
}