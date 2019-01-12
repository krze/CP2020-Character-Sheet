//
//  SkillTableViewCellDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/12/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

protocol SkillTableViewCellDelegate: class {
    
    func cellHeightDidChange(_ cell: SkillTableViewCell)
    
}
