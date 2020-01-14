//
//  Button.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/14/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

struct ButtonModel: MarginCreator {
    let paddingRatio = StyleConstants.SizeConstants.textPaddingRatio
    let frame: CGRect
    
    let unselectedBackgroundColor = StyleConstants.Color.light
    let selectedBackgroundColor = StyleConstants.Color.dark
    
    let selectedTextColor = StyleConstants.Color.light
    let unselectedTextColor = StyleConstants.Color.dark
}

final class Button: UIControl {
    
    private let container: UIView
    private let label: UILabel
    var tapAction: (() -> Void)?
    private let viewModel: ButtonModel
    
    init(model: ButtonModel) {
        viewModel = model
        
        func labelMaker(frame: CGRect) -> UILabel {
            let label = CommonEntryConstructor.headerLabel(frame: frame)
            label.backgroundColor = model.unselectedBackgroundColor
            label.textColor = model.unselectedTextColor
            
            return label
        }
        
        let button = UILabel.container(frame: model.frame,
                                       margins: model.createInsets(with: model.frame),
                                       backgroundColor: model.unselectedBackgroundColor,
                                       borderColor: StyleConstants.Color.dark90, borderWidth: StyleConstants.SizeConstants.borderWidth,
                                       labelMaker: labelMaker)
        container = button.container
        label = button.label
        
        label.isUserInteractionEnabled = false
        container.isUserInteractionEnabled = true
    
        super.init(frame: .zero)
        frame = model.frame

        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: model.frame.width),
            container.heightAnchor.constraint(equalToConstant: model.frame.height)
        ])
        
        addTarget(self, action: #selector(selected), for: .touchDown)
        addTarget(self, action: #selector(deselected), for: .touchCancel)
        addTarget(self, action: #selector(deselected), for: .touchUpInside)
        addTarget(self, action: #selector(deselected), for: .touchUpOutside)
        addTarget(self, action: #selector(deselected), for: .touchDragExit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func selected() {
        container.backgroundColor = viewModel.selectedBackgroundColor
        label.backgroundColor = viewModel.selectedBackgroundColor
        label.textColor = viewModel.selectedTextColor
    }
    
    @objc private func deselected() {
        container.backgroundColor = viewModel.unselectedBackgroundColor
        label.backgroundColor = viewModel.unselectedBackgroundColor
        label.textColor = viewModel.unselectedTextColor
    }
}
