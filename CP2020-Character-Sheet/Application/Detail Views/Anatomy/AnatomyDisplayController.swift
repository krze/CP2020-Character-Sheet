//
//  AnatomyDisplayController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class AnatomyDisplayController: StatusTableViewHeaderControlling {
    
    private let anatomyView: AnatomyDisplayView
    private var valueLabels = [BodyLocation: UILabel]()
    
    init(_ anatomyView: AnatomyDisplayView) {
        self.anatomyView = anatomyView
        
        BodyLocation.allCases.forEach { location in
            let descriptionView = createDescriptionView(for: location)
            valueLabels[location] = descriptionView.valueLabel
            view(for: location).addDescriptionView(descriptionView.wholeView)
        }
    }
    
    func updateSPAccessoryView(for part: BodyLocation, newValue: String) {
        let label = valueLabels[part]
        label?.text = newValue
        label?.fitTextToBounds()
    }
    
    func updateSPAccessoryView(for part: BodyLocation, newValue: BodyPartStatus) {
        view(for: part).setStatus(newValue)
    }
    
    private func view(for part: BodyLocation) -> BodyPartView {
        switch part {
        case .Head: return anatomyView.head
        case .Torso: return anatomyView.torso
        case .LeftArm: return anatomyView.leftArm
        case .RightArm: return anatomyView.rightArm
        case .LeftLeg: return anatomyView.leftLeg
        case .RightLeg: return anatomyView.rightLeg
        }
    }
    
    private func createDescriptionView(for part: BodyLocation) -> (wholeView: UIView, valueLabel: UILabel) {
        let distance = AnatomyDisplayView.Constants.heightAsStatusHeaderView * AnatomyDisplayView.Constants.accessoryViewSizeRatio
        let size = CGSize(width: distance, height: distance)
        let frame = CGRect(origin: .zero, size: size)
        
        return CommonEntryConstructor.simpleHeaderValueCell(frame: frame, labelHeightRatio: 0.35, headerText: part.labelText())
    }
    
}
