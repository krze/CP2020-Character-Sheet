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

protocol SaveRollManagerDelegate: class {
    
    func saveResolved(with button: UIButton, success: Bool, text: String?)
    
}

final class SaveRollView: UIView, PopupViewDismissing, SaveRollManagerDelegate {
    
    var dissmiss: (() -> Void)?
    
    private let manager = SaveRollViewManager()
    private var buttons = [UIButton]()
    
    func setup(with viewModel: SaveRollViewModel, damageModel: DamageModel?) {
        manager.delegate = self
        manager.append(rolls: viewModel.rolls)
        manager.damageModel = damageModel
        
        // MARK: Stackview Setup

        let stackView = UIStackView(frame: bounds)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        stackView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
        
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
        
        let buttons = self.buttons(withHeightPerButton: viewModel.buttonHeight)
        buttons.forEach({ stackView.addArrangedSubview($0) })
        self.buttons = buttons
        
        let bottomFillerView = UIView(frame: CGRect(origin: .zero, size: fillerSize))
        bottomFillerView.backgroundColor = StyleConstants.Color.light
        
        stackView.addArrangedSubview(bottomFillerView)
    }
    
    // MARK: - SaveRollManagerDelegate
    
    func saveResolved(with button: UIButton, success: Bool, text: String?) {
        button.clipsToBounds = true
        
        let overlayStartOrigin = CGPoint(x: button.bounds.origin.x + button.bounds.width, y: button.bounds.minY)
        let overlayEndOrigin = button.bounds.origin
        let overlayStartFrame = CGRect(origin: overlayStartOrigin, size: button.bounds.size)
        let overlayLabel = UILabel(frame: overlayStartFrame)
        
        overlayLabel.font = StyleConstants.Font.defaultBold
        overlayLabel.textColor = StyleConstants.Color.light
        overlayLabel.textAlignment = .center
        
        if success {
            overlayLabel.backgroundColor = StyleConstants.Color.green
            overlayLabel.text = text ?? "Success"
        }
        else {
            overlayLabel.backgroundColor = StyleConstants.Color.red
            overlayLabel.text = text ?? "Failed"
        }
        
        button.addSubview(overlayLabel)
        
        UIView.animate(withDuration: 0.5) {
            overlayLabel.frame.origin = overlayEndOrigin
        }
        
        if success {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.dissmiss?()
            }
        }
    }
    
    // MARK: - Private
    
    @objc private func buttonWasTapped(_ sender: UIButton) {
        buttons.forEach { $0.isUserInteractionEnabled = false }
        
        let untappedButtons = buttons.filter { $0 != sender }
                
        UIView.animate(withDuration: 0.25) {
            untappedButtons.forEach { self.greyOut($0) }
        }
        
    }
    
    private func greyOut(_ button: UIButton) {
        button.backgroundColor = StyleConstants.Color.gray
        button.titleLabel?.textColor = StyleConstants.Color.light
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
                    button.addTarget(manager, action: #selector(manager.resolveRolls(_ :)), for: .touchUpInside)
                case .dismissAll:
                    button.addTarget(manager, action: #selector(manager.dismiss), for: .touchUpInside)
                case .acceptStun:
                    button.addTarget(manager, action: #selector(manager.acceptStunned), for: .touchUpInside)
                case .acceptDeath:
                    button.addTarget(manager, action: #selector(manager.acceptDeath), for: .touchUpInside)
                }
                
                button.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
                
                buttons.append(button)
            }
        }
                
        return buttons
    }
    
    private enum SaveRollButtonMapping: CaseIterable {
        case resolveAll, dismissAll, acceptStun, acceptDeath
    }
}
