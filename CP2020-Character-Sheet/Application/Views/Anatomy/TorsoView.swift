//
//  TorsoView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/16/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class TorsoView: UIView, BodyPartView {

    let location: BodyLocation = .Torso
    private(set) var descriptionView: UIView?
    
    private let torso = UIImageView(image: UIImage(named: "torso-thick")?.withRenderingMode(.alwaysTemplate))
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupInitialSubviews()
    }
    
    private func setupInitialSubviews() {
        torso.translatesAutoresizingMaskIntoConstraints = false

        addSubview(torso)

        torso.tintColor = StyleConstants.Color.dark

        NSLayoutConstraint.activate([
            torso.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            NSLayoutConstraint(item: torso, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.75, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStatus(_ status: BodyPartStatusIndicating) {
        torso.tintColor = status.color()
    }
    
    func addDescriptionView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingConstant = AnatomyDisplayView.Constants.heightAsStatusHeaderView * StyleConstants.Size.edgePaddingRatio
        let distanceFromCenterX = AnatomyDisplayView.Constants.heightAsStatusHeaderView * 0.3

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: view.frame.width),
            view.heightAnchor.constraint(equalToConstant: view.frame.height),
            view.leadingAnchor.constraint(equalTo: centerXAnchor, constant: distanceFromCenterX),
            view.topAnchor.constraint(equalTo: topAnchor, constant: paddingConstant)
        ])
    }
    
}
