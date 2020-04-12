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

protocol PopupViewDismissing: UIView {
    var dismiss: (() -> Void)? { get set }
}

final class PopupViewController: UIViewController {
    
    private(set) var contentView: UIView?
    private let contentViewHeight: CGFloat
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var stackViewHeightConstraint: NSLayoutConstraint?
    
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.contentSize = contentView.bounds.size
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        scrollView.addSubview(stackView)
        
        let stackViewHeightConstraint = stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: contentViewHeight)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            stackView.widthAnchor.constraint(equalToConstant: view.frame.width),
            stackViewHeightConstraint
        ])
        
        self.stackViewHeightConstraint = stackViewHeightConstraint
        
        // Add the content view
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.heightAnchor.constraint(equalToConstant: contentViewHeight).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
                
        stackView.insertArrangedSubview(contentView, at: 0)
        scrollView.contentSize = contentView.frame.size
    }
    
    func dismiss() {
        self.dismiss(animated: true)
    }
    
    func addNewViewToStack(_ newView: UIView, contentHeight: CGFloat) {
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
        newView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        stackView.insertArrangedSubview(newView, at: 0)

        resizeStackView(adding: contentHeight)
    }
    
    private func resizeStackView(adding height: CGFloat) {
        let oldHeight = stackView.frame.height
        stackViewHeightConstraint?.isActive = false
        
        let newHeight = oldHeight + height
        scrollView.contentSize = CGSize(width: view.frame.width, height: newHeight)
        let newConstraint = stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: newHeight)
        newConstraint.isActive = true
        
        stackViewHeightConstraint = newConstraint
        
        scrollView.contentOffset = CGPoint(x: 0.0, y: height)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentOffset = .zero
        })
    }
    
}
