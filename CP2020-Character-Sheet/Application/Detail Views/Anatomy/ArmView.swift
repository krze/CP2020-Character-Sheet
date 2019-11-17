//
//  ArmView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/16/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class ArmView: UIView, BodyPartView {
    
    enum Side: String {
        case left, right
        
        func locationEquivalent() -> BodyLocation {
            switch self {
            case .left: return .LeftArm
            case .right: return .RightArm
            }
        }
    }
    
    let location: BodyLocation
    
    private(set) var descriptionView: UIView?
    private let arm: UIImageView
    
    init(side: Side) {
        location = side.locationEquivalent()
        arm = UIImageView(image: UIImage(named: "\(side.rawValue)-arm-thick")?.withRenderingMode(.alwaysTemplate))
        super.init(frame: .zero)
        backgroundColor = .clear
        setupInitialSubviews()
    }
    
    private func setupInitialSubviews() {
        arm.translatesAutoresizingMaskIntoConstraints = false
        
        let side = location == .RightArm ? Side.right : Side.left
        let horizontalMultiplier: CGFloat = side == .left ? 1.375 : 0.625
        
        addSubview(arm)

        arm.tintColor = StyleConstants.Color.dark

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: arm, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.75, constant: 0),
            NSLayoutConstraint(item: arm, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: horizontalMultiplier, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStatus(_ status: BodyPartStatus) {
        arm.tintColor = status.color()
    }
    
    func addDescriptionView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
