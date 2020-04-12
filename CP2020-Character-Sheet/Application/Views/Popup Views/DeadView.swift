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
    let descriptionHeight: CGFloat = 135.0
    let counterHeight: CGFloat = 65.0
    let buttonSize = CGSize(width: 44.0, height: 44.0)
    let padding: CGFloat = 15.0
    let state: LivingState
    
    func totalHeight() -> CGFloat {
        return titleHeight + descriptionHeight + counterHeight + (padding * 2)
    }
}

final class DeadView: UIView, PopupViewDismissing {
    
    private let stackView = UIStackView()
    private let manager: DeadViewManager
    private var counterLabel: UILabel?
    
    var dismiss: (() -> Void)?
    
    init(frame: CGRect, manager: DeadViewManager) {
        self.manager = manager
        
        super.init(frame: frame)
    }
    
    func setup(with viewModel: DeadViewModel) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = viewModel.padding
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: viewModel.padding),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -viewModel.padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        let titleLabel = CommonViews.headerLabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = viewModel.title
        titleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: viewModel.titleHeight),
            titleLabel.widthAnchor.constraint(equalToConstant: frame.width - (viewModel.padding * 2))
        ])
        
        titleLabel.fitTextToBounds()
        stackView.addArrangedSubview(titleLabel)
        
        let descriptionLabel = CommonViews.headerLabel(frame: .zero)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = viewModel.description
        descriptionLabel.font = StyleConstants.Font.defaultFont
        
        NSLayoutConstraint.activate([
            descriptionLabel.heightAnchor.constraint(equalToConstant: viewModel.descriptionHeight),
            descriptionLabel.widthAnchor.constraint(equalToConstant: frame.width - (viewModel.padding * 2))
        ])
        
        descriptionLabel.fitTextToBounds()
        stackView.addArrangedSubview(descriptionLabel)
        
        let buttonBar = setupButtonBar(with: viewModel)
        
        stackView.addArrangedSubview(buttonBar)
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
        
        // Counter Label
        guard let counterFont = StyleConstants.Font.defaultBold?.withSize(22.0) else { return containerView }
        let counterText = viewModel.state.descriptionText()
        let estimatedSize = counterText.size(withAttributes: [.font: counterFont])
        let headerLabelSize = CGSize(width: estimatedSize.width, height: viewModel.counterHeight)
        let headerFrame = CGRect(origin: .zero, size: headerLabelSize)
        let label = CommonViews.headerLabel(frame: headerFrame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = counterFont
        label.text = counterText
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: estimatedSize.width),
            label.heightAnchor.constraint(equalToConstant: viewModel.counterHeight),
        ])
        containerView.addArrangedSubview(label)
        counterLabel = label
        
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
