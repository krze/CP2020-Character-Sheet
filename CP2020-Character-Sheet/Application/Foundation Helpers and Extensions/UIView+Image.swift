//
//  UIView+Image.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/31/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Converts a UIView to a UIImage
    ///
    /// - Returns: UIImage from the view
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

