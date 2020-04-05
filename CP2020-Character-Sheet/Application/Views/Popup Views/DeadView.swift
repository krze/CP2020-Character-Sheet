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
    
    let titleHeight: CGFloat = 56.0
    let descriptionHeight: CGFloat = 96.0
    let counterHeight: CGFloat = 65.0
    let buttonSize = CGSize(width: 44.0, height: 44.0)
    let padding: CGFloat = 15.0
    let state: LivingState
    
    func totalHeight() -> CGFloat {
        return titleHeight + descriptionHeight + counterHeight + buttonSize.height + (padding * 3)
    }
}

final class DeadView: UIView {
    
    private let stackView = UIStackView()
    private let manager: DeadViewManager
    private var counterLabel: UILabel?
    
    init(frame: CGRect, viewModel: DeadViewModel, manager: DeadViewManager) {
        self.manager = manager
        
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
        
        minusButton.addTarget(self, action: #selector(decrementDeadState(_:)), for: .touchUpInside)
        containerView.addArrangedSubview(minusButton)
        
        // Title
        guard let defaultBold = StyleConstants.Font.defaultBold else { return containerView }
        let headerText = viewModel.state.descriptionText()
        let estimatedSize = headerText.size(withAttributes: [.font: defaultBold])
        let headerLabelSize = CGSize(width: estimatedSize.width, height: viewModel.counterHeight)
        let headerFrame = CGRect(origin: .zero, size: headerLabelSize)
        let label = CommonViews.headerLabel(frame: headerFrame)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: estimatedSize.width),
            label.heightAnchor.constraint(equalToConstant: viewModel.counterHeight),
        ])
        
        // Plus Button
        let plusButton = CommonViews.roundedCornerButton(frame: buttonFrame, title: "+")
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: viewModel.buttonSize.width),
            plusButton.heightAnchor.constraint(equalToConstant: viewModel.buttonSize.height),
        ])
        
        plusButton.addTarget(self, action: #selector(incrementDeadState(_:)), for: .touchUpInside)
        containerView.addArrangedSubview(plusButton)
        
        return containerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func incrementDeadState(_ sender: UIButton) {
        guard let newValue = manager.incrementDeadState() else { return }
        counterLabel?.text = newValue.descriptionText()
        counterLabel?.fitTextToBounds()
    }
    
    @objc private func decrementDeadState(_ sender: UIButton) {
        guard let newValue = manager.decrementDeadState() else { return }
        counterLabel?.text = newValue.descriptionText()
        counterLabel?.fitTextToBounds()
    }
    
}
