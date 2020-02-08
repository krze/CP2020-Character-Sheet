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
    
    /// Height to contain the description view
    let descriptionHeight: CGFloat = 88
    
    /// Height to contain the buttons
    let buttonHeight: CGFloat = 44
    
    /// Height for each roll.
    let rollHeight: CGFloat = 44
    
    let buttonCount = 4
    
    func totalHeight() -> CGFloat {
        return descriptionHeight + heightForButtons() + heightForRolls()
    }
    
    /// Total height to contain the list of all the rolls
    func heightForRolls() -> CGFloat {
        floor(CGFloat(rolls.count)) * rollHeight
    }
    
    /// Total height to contain the height for all the buttons
    func heightForButtons() -> CGFloat {
        return buttonHeight * floor(CGFloat(buttonCount))
    }
    
}

final class SaveRollView: UIView, PopupViewDismissing {
    
    var dissmiss: (() -> Void)?
    
    private let manager = SaveRollViewManager()
    
    func setup(with viewModel: SaveRollViewModel) {
        manager.append(rolls: viewModel.rolls)
        
        // MARK: Stackview Setup

        let stackView = UIStackView(frame: bounds)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)
        
        let fillerSize = CGSize(width: bounds.width, height: bounds.height * 0.05)
        let topFillerView = UIView(frame: CGRect(origin: .zero, size: fillerSize))
        topFillerView.backgroundColor = StyleConstants.Color.light
        
        stackView.addArrangedSubview(topFillerView)
        
        // MARK: Description label
        
        let descriptionSize = CGSize(width: bounds.width, height: viewModel.descriptionHeight)
        let descriptionLabel = CommonViews.headerLabel(frame:  CGRect(origin: .zero, size: descriptionSize))
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = true
        descriptionLabel.text = SaveRollStrings.saveRollViewDescription
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(descriptionLabel)
        
        // MARK: Roll label
        
        let rollSize = CGSize(width: bounds.width, height: viewModel.heightForRolls())
        let rollLabel = CommonViews.headerLabel(frame: CGRect(origin: .zero, size: rollSize))
        rollLabel.translatesAutoresizingMaskIntoConstraints = true
        rollLabel.text = saveRollString(from: viewModel.rolls)
        rollLabel.textAlignment = .center
        rollLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(rollLabel)
        
        // MARK: Buttons
        
        buttons(withHeightPerButton: viewModel.buttonHeight).forEach { stackView.addArrangedSubview($0) }
        
        let bottomFillerView = UIView(frame: CGRect(origin: .zero, size: fillerSize))
        bottomFillerView.backgroundColor = StyleConstants.Color.light
        
        stackView.addArrangedSubview(bottomFillerView)
    }
    
    @objc private func dismissPopup() {
        dissmiss?()
    }
    
    private func saveRollString(from rolls: [SaveRoll]) -> String {
        return rolls.map({ "\($0.type.rawValue) <= \($0.target)" }).joined(separator: "\n")
    }
    
    /// Creates the buttons used
    /// - Parameter height: Height for each button
    private func buttons(withHeightPerButton height: CGFloat) -> [Button] {
        let labelTexts: [SaveRollButtonMapping: String] = [
            .resolveAll: SaveRollStrings.resolveAllRolls,
            .dismissAll: SaveRollStrings.resolveWithoutRolling,
            .acceptStun: SaveRollStrings.acceptStunState,
            .acceptDeath: SaveRollStrings.acceptDeathState
        ]
        
        var buttons = [Button]()
        
        // This is done so they come out in order
        
        SaveRollButtonMapping.allCases.forEach { mapping in
            if let title = labelTexts[mapping] {
                let buttonSize = CGSize(width: bounds.width, height: height)
                let buttonFrame = CGRect(origin: .zero, size: buttonSize)
                let button = CommonViews.roundedCornerButton(frame: buttonFrame, title: title)
                button.widthAnchor.constraint(equalToConstant: bounds.width * 0.95).isActive = true

                
                switch mapping {
                case .resolveAll:
                    button.addTarget(manager, action: #selector(manager.resolveRolls), for: .touchUpInside)
                case .dismissAll:
                    button.addTarget(manager, action: #selector(manager.dismiss), for: .touchUpInside)
                case .acceptStun:
                    button.addTarget(manager, action: #selector(manager.acceptStunned), for: .touchUpInside)
                case .acceptDeath:
                    button.addTarget(manager, action: #selector(manager.acceptDeath), for: .touchUpInside)
                }
                
                button.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
                
                buttons.append(button)
            }
        }
                
        return buttons
    }
    
    private enum SaveRollButtonMapping: CaseIterable {
        case resolveAll, dismissAll, acceptStun, acceptDeath
    }
}
