//
//  RoleViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/15/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct RoleViewModel: MarginCreator {
    
    let paddingRatio: CGFloat
    let classLabelText = RoleFieldLabel.characterClass
    let roleType: Role
    let classLabelWidthRatio: CGFloat
    var classDescriptionWidthRatio: CGFloat {
        return 1.0 - classLabelWidthRatio
    }
    
    let classLabelFont = StyleConstants.Font.defaultBold
    let classDescriptionFont = StyleConstants.Font.defaultFont
    let darkColor = StyleConstants.Color.dark
    let lightColor = StyleConstants.Color.light

}
