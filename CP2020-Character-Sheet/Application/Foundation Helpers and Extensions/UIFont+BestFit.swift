import UIKit

extension UIFont {
    
    /// Will return the best size conforming to the descriptor which will fit in the provided bounds.
    ///
    /// - Parameters:
    ///   - text: The string that's in use
    ///   - bounds: Bounds of the view to fit
    ///   - fontDescriptor: The font's descriptor
    ///   - additionalAttributes: Additional NSAttributedString attributes
    ///   - maximumFontSize: An optional limit to the upper bounds of your max font size.
    /// - Returns: GGFloat representing the font size that best fits in the bounds
    static func bestFittingFontSize(for text: String, in bounds: CGRect, fontDescriptor: UIFontDescriptor, additionalAttributes: [NSAttributedString.Key: Any]? = nil, maximumFontSize: CGFloat? = nil) -> CGFloat {
        let constrainingDimension = min(bounds.width, bounds.height)
        let properBounds = CGRect(origin: .zero, size: bounds.size)
        var attributes = additionalAttributes ?? [:]
        
        let infiniteBounds = CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
        var bestFontSize: CGFloat = {
            guard let maximumFontSize = maximumFontSize else {
                return constrainingDimension
            }
            
            return maximumFontSize < constrainingDimension ? maximumFontSize : constrainingDimension
        }()
        
        for fontSize in stride(from: bestFontSize, through: 0, by: -1) {
            let newFont = UIFont(descriptor: fontDescriptor, size: fontSize)
            attributes[.font] = newFont
            
            let currentFrame = text.boundingRect(with: infiniteBounds, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
            
            if properBounds.contains(currentFrame) {
                bestFontSize = fontSize
                break
            }
        }
        return bestFontSize
    }
    
    /// Will return the best font conforming to the descriptor which will fit in the provided bounds.
    ///
    /// - Parameters:
    ///   - text: The string that's in use
    ///   - bounds: Bounds of the view to fit
    ///   - fontDescriptor: The font's descriptor
    ///   - additionalAttributes: Additional NSAttributedString attributes
    ///   - maximumFontSize: An optional limit to the upper bounds of your maximum font size
    /// - Returns: UIFont representing the font that best fits in the bounds
    static func bestFittingFont(for text: String, in bounds: CGRect, fontDescriptor: UIFontDescriptor, additionalAttributes: [NSAttributedString.Key: Any]? = nil, maximumFontSize: CGFloat? = nil) -> UIFont {
        let bestSize = bestFittingFontSize(for: text, in: bounds, fontDescriptor: fontDescriptor, additionalAttributes: additionalAttributes, maximumFontSize: maximumFontSize)
        return UIFont(descriptor: fontDescriptor, size: bestSize)
    }
}

extension UILabel {
    
    /// Will auto resize the contained text to a font size which fits the frames bounds.
    /// Uses the pre-set font to dynamically determine the proper sizing
    ///
    /// - Parameter maximumSize: An optional limit to max font size.
    func fitTextToBounds(maximumSize: CGFloat? = nil) {
        guard let text = text, let currentFont = font else { return }
        
        let bestFittingFont = UIFont.bestFittingFont(for: text, in: bounds, fontDescriptor: currentFont.fontDescriptor, additionalAttributes: basicStringAttributes, maximumFontSize: maximumSize)
        font = bestFittingFont
    }
    
    private var basicStringAttributes: [NSAttributedString.Key: Any] {
        var attribs = [NSAttributedString.Key: Any]()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = self.lineBreakMode
        attribs[.paragraphStyle] = paragraphStyle
        
        return attribs
    }
}
