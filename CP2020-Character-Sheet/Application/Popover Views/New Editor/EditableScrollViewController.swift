//
//  EditableScrollViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/13/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

/// Used for skills for now but this will eventually be the view controller for editing any section of the character.
/// Take two of EditorViewController. Eventually EditorViewController will be depreated.
///
/// NEXT: Do this shit below VVV
/// - Give this class a spin and plug in the values/first responders/etc
/// - Settle how to create immutable rows as an "entry type"
/// - When creating a new skill, figure out how to autofill existing skills
final class EditableScrollViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let stackView: UIStackView
    private let printerPaperView: PrinterPaperView
    private let fields: [UserEntryView]
    
    
    private let viewModel: EditableScrollViewModel
    
    /// Creates a EditableScrollViewController.
    ///
    /// - Parameters:
    ///   - viewModel: EditableScrollViewModel dictacting the contents of the view
    ///   - size: A size representing the view to fill.
    init(viewModel: EditableScrollViewModel, size: CGSize) {
        self.viewModel = viewModel
        let placeholderFrame = CGRect(origin: CGPoint.zero, size: size)
        self.printerPaperView = PrinterPaperView(frame: placeholderFrame, viewModel: PrinterPaperViewModel())
        let rows = UserEntryViewCollectionFactory(viewModel: viewModel).stackedEntryRows(frame: printerPaperView.contentView.frame, windowForPicker: nil)
        self.stackView = rows.stackView
        self.fields = rows.entryRows
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a blur view to cover the whole frame
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .dark)
        
        view.addSubview(blurView)
        
        // Add the scroll view and pin it to the whole frame
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        
        // Add the decoration view
        
        scrollView.addSubview(printerPaperView)
        
        NSLayoutConstraint.activate([
            printerPaperView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            printerPaperView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            printerPaperView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            printerPaperView.heightAnchor.constraint(equalToConstant: viewModel.minimumHeightForAllRows),
            printerPaperView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
        
        // Add the stack view to the printer paper content view
        
        printerPaperView.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: printerPaperView.contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: printerPaperView.contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: printerPaperView.contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: printerPaperView.contentView.bottomAnchor)
            ])
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
