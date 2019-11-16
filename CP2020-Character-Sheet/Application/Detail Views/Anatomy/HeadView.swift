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
    
    private let head = UIImageView(image: UIImage(named: "head-thick"))
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupInitialSubviews()
    }
    
    private func setupInitialSubviews() {
        head.translatesAutoresizingMaskIntoConstraints = false

        addSubview(head)

        NSLayoutConstraint.activate([
            head.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            head.centerYAnchor.constraint(equalTo: self.centerYAnchor)
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
    }
    
}
