//
//  StatusTableView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/16/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

protocol StatusTableViewHeaderControlling {
    
    var tableView: UITableView? { get set }
    
}

/// A configurable tableview with a static header, and a scrollable table below.
/// The purpose of this tableview is to provide a detailed status screen of some type,
/// with items in the tableview that can affect the status. For example, a StatusTableView
/// for armor can contain a diagram of your armor per location in the static header, and an
/// editable list of worn armor within the tableview.
final class StatusTableView: UIViewController {
    private var headerViewController: StatusTableViewHeaderControlling?
    private let viewHeader: UIView
    private let viewHeaderHeight: CGFloat
    private let tableView: UITableView
    private let tableViewManager: TableViewManaging?
    
    init(with model: StatusTableViewModel, headerViewController: StatusTableViewHeaderControlling?) {
        viewHeaderHeight = model.viewHeaderHeight
        viewHeader = model.viewHeader
        tableView = UITableView()
        tableViewManager = model.dataSource
        self.headerViewController = headerViewController
        
        super.init(nibName: nil, bundle: nil)
        
        model.navigationBarEdtingClosure?(self.navigationItem)
        
        title = model.title
        view.backgroundColor = StyleConstants.Color.dark
        tableView.dataSource = tableViewManager
        tableView.delegate = tableViewManager
        
        self.headerViewController?.tableView = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: TableView setup
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: viewHeaderHeight)
        ])
        
        tableViewManager?.registerCells(for: tableView)
        
        // MARK: Header layout
        
        viewHeader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewHeader)
        
        NSLayoutConstraint.activate([
            viewHeader.heightAnchor.constraint(equalToConstant: viewHeaderHeight),
            viewHeader.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            viewHeader.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            viewHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
