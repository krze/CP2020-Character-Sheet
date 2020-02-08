//
//  SaveRollView.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/13/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

struct SaveRollViewModel {
    
    let rolls: [SaveRoll]
    let descriptionHeight: CGFloat = 88
    let rollHeight: CGFloat = 44
    
    func totalHeight() -> CGFloat {
        return descriptionHeight + (floor(CGFloat(rolls.count)) * descriptionHeight)
    }
}

final class SaveRollView: UIView, PopupViewDismissing {
    
    var dissmiss: (() -> Void)?
    
    private let manager = SaveRollViewManager()
    
    func setup(with viewModel: SaveRollViewModel) {
        manager.append(rolls: viewModel.rolls)
        let stackView = UIStackView(frame: bounds)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)
        
        let descriptionSize = CGSize(width: bounds.width, height: viewModel.descriptionHeight)
        let descriptionLabel = CommonViews.headerLabel(frame:  CGRect(origin: .zero, size: descriptionSize))
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = true
        descriptionLabel.text = SaveRollStrings.saveRollViewDescription
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(descriptionLabel)
        
        let buttonSize = CGSize(width: bounds.width, height: viewModel.rollHeight)
        let buttonFrame = CGRect(origin: .zero, size: buttonSize)
        let button = CommonViews.roundedCornerButton(frame: buttonFrame, title: "TEST")
        button.widthAnchor.constraint(equalToConstant: bounds.width * 0.95).isActive = true
        
        stackView.addArrangedSubview(button)
    }
    
    @objc private func dismissPopup() {
        dissmiss?()
    }
}
