//
//  LegView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/16/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class LegView: UIView, BodyPartView {
    
    enum Side: String {
        case left, right
        
        func locationEquivalent() -> BodyLocation {
            switch self {
            case .left: return .LeftLeg
            case .right: return .RightLeg
            }
        }
    }
    
    let location: BodyLocation
    
    private(set) var descriptionView: UIView?
    private let leg: UIImageView
    
    init(side: Side) {
        location = side.locationEquivalent()
        leg = UIImageView(image: UIImage(named: "leg-thick")?.withRenderingMode(.alwaysTemplate))
        super.init(frame: .zero)
        backgroundColor = .clear
        setupInitialSubviews()
    }
    
    private func setupInitialSubviews() {
        leg.translatesAutoresizingMaskIntoConstraints = false
        
        let side = location == .RightLeg ? Side.right : Side.left
        let horizontalMultiplier: CGFloat = side == .left ? 1.10 : 0.90
        addSubview(leg)

        leg.tintColor = StyleConstants.Color.dark

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: leg, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.40, constant: 0),
            NSLayoutConstraint(item: leg, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: horizontalMultiplier, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStatus(_ status: BodyPartStatus) {
        leg.tintColor = status.color()
    }
    
    func addDescriptionView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
