//
//  CheckBoxView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

struct CheckboxContainerModel: MarginCreator {
    let paddingRatio = StyleConstants.SizeConstants.textPaddingRatio
    let frame: CGRect
    
    let unselectedBackgroundColor = StyleConstants.Color.light
    let selectedBackgroundColor = StyleConstants.Color.dark
    
    let selectedTextColor = StyleConstants.Color.light
    let unselectedTextColor = StyleConstants.Color.dark
}

final class Checkbox {
    
    let container: UIView
    let label: UILabel
    
    private(set) var selected = false
    
    private let viewModel: CheckboxContainerModel
    
    init(model: CheckboxContainerModel) {
        viewModel = model
        
        func labelMaker(frame: CGRect) -> UILabel {
            let label = CommonEntryConstructor.headerLabel(frame: frame)
            label.backgroundColor = model.unselectedBackgroundColor
            label.textColor = model.unselectedTextColor
            
            return label
        }
        
        let checkbox = UILabel.container(frame: model.frame,
                                         margins: model.createInsets(with: model.frame),
                                         backgroundColor: model.unselectedBackgroundColor,
                                         borderColor: nil, borderWidth: nil,
                                         labelMaker: labelMaker)
        container = checkbox.container
        label = checkbox.label
        
        label.isUserInteractionEnabled = false
        container.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        
        tap.cancelsTouchesInView = false
        container.addGestureRecognizer(tap)
    }
    
    @objc private func tapped() {
        selected = !selected
        
        if selected {
            container.backgroundColor = viewModel.selectedBackgroundColor
            label.backgroundColor = viewModel.selectedBackgroundColor
            label.textColor = viewModel.selectedTextColor
        }
        else {
            container.backgroundColor = viewModel.unselectedBackgroundColor
            label.backgroundColor = viewModel.unselectedBackgroundColor
            label.textColor = viewModel.unselectedTextColor
        }
        
    }
    
}
