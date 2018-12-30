//
//  HighlightedSkillViewCellDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/22/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class HighlightedSkillViewCellDataSource {
    
    func showSkillTable() {
        NotificationCenter.default.post(name: .showSkillTable, object: nil)
    }
    
}
