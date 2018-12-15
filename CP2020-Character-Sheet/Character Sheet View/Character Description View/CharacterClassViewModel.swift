//
//  CharacterClassViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/15/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct CharacterClassViewModel: MarginCreator {
    
    let paddingRatio: CGFloat
    let classLabelText = CharacterDescriptionConstants.Text.characterClass
    let classType: CharacterClass
    let classLabelWidthRatio: CGFloat
    var classDescriptionWidthRatio: CGFloat {
        return 1.0 - classLabelWidthRatio
    }
    
    let classLabelFont = StyleConstants.Font.defaultBold
    let classDescriptionFont = StyleConstants.Font.defaultFont
    let darkColor = StyleConstants.Color.dark
    let lightColor = StyleConstants.Color.light

}
