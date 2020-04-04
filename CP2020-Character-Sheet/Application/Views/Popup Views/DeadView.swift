//
//  DeadView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 4/4/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

struct DeadViewModel {
    let title = PlayerStateStrings.deadViewTitle
    let description = PlayerStateStrings.deadViewDescription
    let counterText = PlayerStateStrings.deadCounterText
    
    let titleHeight: CGFloat = 56.0
    let descriptionHeight: CGFloat = 96.0
    let counterHeight: CGFloat = 65.0
    let buttonSize = CGSize(width: 65.0, height: 65.0)
    let padding: CGFloat = 15.0
}

final class DeadViewManager {
    private weak var model: LivingStateModel?
    
    init(model: LivingStateModel) {
        self.model = model
    }
    
    func canChange(direction: Direction) -> Bool {
        guard let deadState = model?.livingState, deadState.rawValue >= 0 else { return false }
        
        switch direction {
            case .down: return deadState.rawValue >= 1
            case .up: return deadState.rawValue <= 9
        }
    }
    
    func incrementDeadState() {
        guard canChange(direction: .up), let deadState = model?.livingState else { return }
        let newValue = deadState.rawValue + 1
        
        if let newState = LivingState(rawValue: newValue) {
            model?.enter(livingState: newState, completion: defaultCompletion)
        }
    }
    
    func decrementDeadState() {
        guard canChange(direction: .down), let deadState = model?.livingState else { return }
        let newValue = deadState.rawValue - 1
        
        if let newState = LivingState(rawValue: newValue) {
            model?.enter(livingState: newState, completion: defaultCompletion)
        }

    }
    
    func clearDeadState() {
        model?.enter(livingState: .alive, completion: defaultCompletion)
    }
    
    enum Direction {
        case up, down
    }
}

final class DeadView: UIView {
    
    private let stackView = UIStackView()
    
    init(frame: CGRect, viewModel: DeadViewModel) {
        super.init(frame: frame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = viewModel.padding
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: viewModel.padding),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: viewModel.padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupButtonBar(with viewModel: DeadViewModel) -> UIView {
        let containerView = UIStackView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.heightAnchor.constraint(equalToConstant: viewModel.counterHeight).isActive = true
        
        containerView.axis = .horizontal
        containerView.alignment = .center
        containerView.distribution = .fill
        containerView.spacing = viewModel.padding
        
        // Minus Button
        
        let buttonFrame = CGRect(origin: .zero, size: viewModel.buttonSize)
        let minusButton = CommonViews.roundedCornerButton(frame: buttonFrame, title: "-")
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            minusButton.widthAnchor.constraint(equalToConstant: viewModel.buttonSize.width),
            minusButton.heightAnchor.constraint(equalToConstant: viewModel.buttonSize.height),
        ])
        
        containerView.addArrangedSubview(minusButton)
        
        // Title
        
        // Plus Button
        let plusButton = CommonViews.roundedCornerButton(frame: buttonFrame, title: "+")
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: viewModel.buttonSize.width),
            plusButton.heightAnchor.constraint(equalToConstant: viewModel.buttonSize.height),
        ])
        
        containerView.addArrangedSubview(plusButton)
        
        return containerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func incrementDeadState() {
        
    }
    
    @objc private func decrementDeadState() {
        
    }
    
}
