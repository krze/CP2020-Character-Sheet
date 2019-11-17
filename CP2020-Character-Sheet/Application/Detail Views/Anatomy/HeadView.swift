//
//  HeadView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/16/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class HeadView: UIView, BodyPartView {

    let location: BodyLocation = .Head
    private(set) var descriptionView: UIView?
    
    private let head = UIImageView(image: UIImage(named: "head-thick")?.withRenderingMode(.alwaysTemplate))
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupInitialSubviews()
    }
    
    private func setupInitialSubviews() {
        head.translatesAutoresizingMaskIntoConstraints = false

        addSubview(head)
        
        head.tintColor = StyleConstants.Color.dark
        
        NSLayoutConstraint.activate([
            head.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            NSLayoutConstraint(item: head, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.25, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStatus(_ status: BodyPartStatus) {
        head.tintColor = status.color()
    }
    
    func addDescriptionView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingConstant = AnatomyDisplayView.Constants.heightAsStatusHeaderView * StyleConstants.SizeConstants.edgePaddingRatio
        let distanceFromCenterX = AnatomyDisplayView.Constants.heightAsStatusHeaderView * 0.3
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: view.frame.width),
            view.heightAnchor.constraint(equalToConstant: view.frame.height),
            view.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -distanceFromCenterX),
            view.topAnchor.constraint(equalTo: topAnchor, constant: paddingConstant)
        ])
    }
    
}
