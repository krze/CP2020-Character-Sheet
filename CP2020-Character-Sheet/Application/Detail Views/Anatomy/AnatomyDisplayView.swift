//
//  AnatomyDisplayView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/16/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A view that displays the character's body. Used to indicate statuses that relate to the location
/// within the body.
final class AnatomyDisplayView: UIView {
    let head: HeadView
    let torso: TorsoView
    let leftArm: ArmView
    let rightArm: ArmView
    let leftLeg: LegView
    let rightLeg: LegView

    init() {
        head = HeadView()
        torso = TorsoView()
        leftArm = ArmView(side: .left)
        rightArm = ArmView(side: .right)
        leftLeg = LegView(side: .left)
        rightLeg = LegView(side: .right)
        
        super.init(frame: .zero)
        
        backgroundColor = StyleConstants.Color.light
        setupInitialSubviews()
    }
    
    private func setupInitialSubviews() {
        let subviews = [head, torso, leftArm, rightArm, leftLeg, rightLeg]
        
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
            
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: topAnchor),
                subview.leadingAnchor.constraint(equalTo: leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
