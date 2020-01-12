//
//  PopupViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/13/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

struct PopupViewModel {
    
    let contentHeight: CGFloat
    let contentView: UIView
    
}

final class PopupViewController: UIViewController {
    
    private(set) var contentView: UIView?
    private let contentViewHeight: CGFloat
    init(with viewModel: PopupViewModel) {
        contentView = viewModel.contentView
        contentViewHeight = viewModel.contentHeight
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = StyleConstants.Color.dark90
        view.alpha = 0.25
        
        guard let contentView = contentView else { return }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0),
            contentView.heightAnchor.constraint(equalToConstant: contentViewHeight),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
