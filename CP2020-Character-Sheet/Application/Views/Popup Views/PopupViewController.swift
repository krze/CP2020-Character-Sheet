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
    let contentView: PopupViewDismissing
    
}

protocol PopupViewDismissing: UIView {
    
    var dissmiss: (() -> Void)? { get set }
    
}

final class PopupViewController: UIViewController {
    
    private(set) var contentView: PopupViewDismissing?
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
        view.backgroundColor = .clear
        
        // Set up the translucent background
        
        let backgroundView = UIView(frame: view.frame)
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = StyleConstants.Color.dark
        backgroundView.alpha = 0.45
        
        guard let contentView = contentView else { return }
        
        // Set up the scrollview with the contenView info
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.backgroundColor = .clear
        scrollView.contentSize = contentView.bounds.size
        view.addSubview(scrollView)
        
        // Add the content view
        
        let origin = CGPoint(x: 0.0, y: view.frame.height * 0.05)
        let frame = CGRect(origin: origin, size: CGSize(width: view.frame.width, height: contentViewHeight))
        contentView.frame = frame
        
        contentView.dissmiss = {
            self.dismiss(animated: true)
        }
        
        scrollView.addSubview(contentView)
    }
    
}
