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
        
        // Calc the offset -- edge aligns w/center  -- Additional offset to the side
        let horizonalOffset = (leg.frame.width / 2) + (leg.frame.width * 0.3)
        let horizontalConstant: CGFloat = side == .left ? horizonalOffset : -horizonalOffset
        
        addSubview(leg)

        leg.tintColor = StyleConstants.Color.dark

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: leg, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.40, constant: 0),
            NSLayoutConstraint(item: leg, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: horizontalConstant)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStatus(_ status: BodyPartStatusIndicating) {
        leg.tintColor = status.color()
    }
    
    func addDescriptionView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingConstant = AnatomyDisplayView.Constants.heightAsStatusHeaderView * StyleConstants.SizeConstants.edgePaddingRatio
        let distanceFromCenterX = AnatomyDisplayView.Constants.heightAsStatusHeaderView * 0.20

        let XAxisConstraint: NSLayoutConstraint = {
            if location == .RightLeg {
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
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingConstant)
        ])
    }
    
}
