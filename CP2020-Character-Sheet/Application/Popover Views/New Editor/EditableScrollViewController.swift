//
//  EditableScrollViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/13/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Used for skills for now but this will eventually be the view controller for editing any section of the character.
/// Take two of EditorViewController
final class EditableScrollViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let viewModel = EditableScrollViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .dark)
        
        view.addSubview(blurView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])

        // Do any additional setup after loading the view.
    }
    
    // MARK: UIPresentationControllerDelegate
    
    @objc func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
