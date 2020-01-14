//
//  SaveRollView.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/13/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

struct SaveRollViewModel {
    
    let rolls: [SaveRoll]
    let descriptionHeight: CGFloat = 88
    let rollHeight: CGFloat = 44
    
    func totalHeight() -> CGFloat {
        return descriptionHeight + (floor(CGFloat(rolls.count)) * descriptionHeight)
    }
}

final class SaveRollView: UIView {
    private let manager = SaveRollViewManager(description: SaveRollStrings.saveRollViewDescription)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with viewModel: SaveRollViewModel) {
        manager.appendRolls(viewModel.rolls)
        let tableView = UITableView()
        tableView.dataSource = manager
        tableView.delegate = manager
        manager.registerCells(for: tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.widthAnchor.constraint(equalTo: widthAnchor),
            tableView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        tableView.reloadData()
    }
}
