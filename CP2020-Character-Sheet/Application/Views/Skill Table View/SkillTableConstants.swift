//
//  SkillTableConstants.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/21/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

struct SkillTableConstants {
    
    static let highlightedSkillTableSectionCount = 1
    static let highlightedSkillTableViewCellCount = 10
    static let highlightedSkillViewHeight: CGFloat = {
        // provides enough height to show the cell count plus a header view
        return ColumnTableConstants.headerHeight + (ColumnTableConstants.rowHeight * CGFloat(highlightedSkillTableViewCellCount))
    }()
}
