//
//  StatusTableView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/16/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A configurable tableview with a static header, and a scrollable table below.
/// The purpose of this tableview is to provide a detailed status screen of some type,
/// with items in the tableview that can affect the status. For example, a StatusTableView
/// for armor can contain a diagram of your armor per location in the static header, and an
/// editable list of worn armor within the tableview.
final class StatusTableView: UITableViewController {
    private let viewHeader: UIView
    private let viewHeaderHeight: CGFloat
    
    init(with model: StatusTableViewModel) {
        viewHeaderHeight = model.viewHeaderHeight
        viewHeader = model.viewHeader
        super.init(style: .plain)
        title = model.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: viewHeaderHeight,
                                              left: 0.0,
                                              bottom: 0.0,
                                              right: 0.0)
        viewHeader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewHeader)
        
        NSLayoutConstraint.activate([
            viewHeader.heightAnchor.constraint(equalToConstant: viewHeaderHeight),
            viewHeader.leftAnchor.constraint(equalTo: view.leftAnchor),
            viewHeader.rightAnchor.constraint(equalTo: view.rightAnchor),
            viewHeader.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
