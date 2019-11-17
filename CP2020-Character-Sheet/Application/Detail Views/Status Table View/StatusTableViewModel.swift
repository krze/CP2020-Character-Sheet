//
//  StatusTableViewModel.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/16/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

struct StatusTableViewModel {
    
    /// The title to be displayed for the status view
    let title: String
    /// The required height of the static header above the scrollable tableview
    let viewHeaderHeight: CGFloat
    /// The heaader view to be placed at the top of the status bar
    let viewHeader: UIView
    /// The data source for the content to be displayed below the header.
    let dataSource: UITableViewDataSource?
    
}
