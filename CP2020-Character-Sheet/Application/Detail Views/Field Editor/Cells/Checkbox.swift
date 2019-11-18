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

protocol CheckboxSelectionDelegate: class {
    
    func checkboxSelected(_ checkbox: Checkbox)
    
    func checkboxDeselected(_ checkbox: Checkbox)
    
    func checkboxTappedWhileSelectionDisabled(_ checkbox: Checkbox)
    
}

final class Checkbox: Hashable {
    
    let container: UIView
    let label: UILabel
    weak var delegate: CheckboxSelectionDelegate?
    
    private(set) var selected = false
    
    /// Prevents selection from occurring. Enabling this will prevent the state from being flipped.
    var selectionPrevented = false
    
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
                                         borderColor: StyleConstants.Color.dark90, borderWidth: StyleConstants.SizeConstants.borderWidth,
                                         labelMaker: labelMaker)
        container = checkbox.container
        label = checkbox.label
        
        label.isUserInteractionEnabled = false
        container.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        
        tap.cancelsTouchesInView = false
        container.addGestureRecognizer(tap)
    }
    
    /// Flips the selection state on the checkbox. This is called when tapped by the user, and selection is not prevented.
    /// This method should only be called if you need to programmatically flip the state for a valid reason.
    func flipSelectionState() {
        selected = !selected
        
        if selected {
            container.backgroundColor = viewModel.selectedBackgroundColor
            label.backgroundColor = viewModel.selectedBackgroundColor
            label.textColor = viewModel.selectedTextColor
            delegate?.checkboxSelected(self)
        }
        else {
            container.backgroundColor = viewModel.unselectedBackgroundColor
            label.backgroundColor = viewModel.unselectedBackgroundColor
            label.textColor = viewModel.unselectedTextColor
            delegate?.checkboxDeselected(self)
        }
    }
    
    @objc private func tapped() {
        guard !selectionPrevented else {
            delegate?.checkboxTappedWhileSelectionDisabled(self)
            return
        }
        
        flipSelectionState()
    }
    
    // MARK: Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(label.text)
        hasher.combine(selected)
        hasher.combine(selectionPrevented)
    }


    static func == (lhs: Checkbox, rhs: Checkbox) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}
