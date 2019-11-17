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
        
        // Calc the offset -- edge aligns w/center  -- Additional offset to the side
        let horizonalOffset = (arm.frame.width / 2) + (arm.frame.width * 0.6)
        let horizontalConstant: CGFloat = side == .left ? horizonalOffset : -horizonalOffset
        
        addSubview(arm)

        arm.tintColor = StyleConstants.Color.dark

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: arm, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.75, constant: 0),
            NSLayoutConstraint(item: arm, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: horizontalConstant)
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
        
        let distanceFromCenterX = AnatomyDisplayView.Constants.heightAsStatusHeaderView * 0.42
        let XAxisConstraint: NSLayoutConstraint = {
            if location == .RightArm {
                return view.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -distanceFromCenterX)
            }
            else {
                return view.leadingAnchor.constraint(equalTo: centerXAnchor, constant: distanceFromCenterX)
            }
        }()
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: view.frame.width),
            view.heightAnchor.constraint(equalToConstant: view.frame.height),
            XAxisConstraint,
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
