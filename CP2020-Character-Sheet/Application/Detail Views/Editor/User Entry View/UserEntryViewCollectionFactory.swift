//
//  UserEntryViewCollectionFactory.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/30/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A helper factory to construct UserEntryView collections
struct UserEntryViewCollectionFactory {
    let viewModel: StackedEntryViewModel // Eventually this will have to be more generic, maybe make the necessary items a protocol.
    private(set) var bottomAnchorForLastRow: NSLayoutYAxisAnchor?
    private(set) var buttonBarPoint: CGPoint?
    private(set) var buttonBarHeight: CGFloat?
    
    init(viewModel: StackedEntryViewModel) {
        self.viewModel = viewModel
    }
    
    /// Adjusts the frame given to the minimum height required to hold a collection of all the user
    /// entry views required by the viewModel.
    ///
    /// - Parameter frame: Target frame
    /// - Returns: Adjusted frame for the minimum required height to hold all UserEntryViews
    func minimumSizedFrameForCollection(from frame: CGRect) -> CGRect {
        return CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: viewModel.minimumHeightForAllRows)
    }
    
    /// Adds the UserEntryViews to the targetView provided.
    /// TODO: Deprecate this with EditorViewController when it is replaced.
    ///
    /// - Parameter targetView: The view to which you want to add a collection of UserEntryViews
    /// - Parameter windowForPicker: The frame representing the window in case a picker needs to be presented.
    /// - Returns: An array of created UserEntryViews
    mutating func addUserEntryViews(to targetView: UIView, windowForPicker pickerWindow: CGRect?) -> [UserEntryView] {
        let entryViewSize = userEntrySize(fromView: targetView, includeButtonHeight: viewModel.includeSpaceForButtons)
        let multipleColumns = viewModel.numberOfColumns > 1
        
        var reversedSortedMutableRowsWithIdentifiers = reversedSortedEntryRows()
        
        var views = [UserEntryView]()
        var leadingAnchor = targetView.leadingAnchor
        var topAnchor = targetView.topAnchor
        var x = targetView.frame.minX
        var y = targetView.frame.minY
        var columnNumber = 1
        
        while !reversedSortedMutableRowsWithIdentifiers.isEmpty {
            guard let (identifierText, type) = reversedSortedMutableRowsWithIdentifiers.popLast(),
                let placeholder = viewModel.placeholdersWithIdentifiers?[identifierText] else { break }
            
            let userEntryViewModel = UserEntryViewModel(type: type,
                                                        identifierText: identifierText,
                                                        identifierWidthRatio: viewModel.labelWidthRatio,
                                                        placeholder: placeholder)
            let frame = CGRect(x: x, y: y, width: entryViewSize.width, height: entryViewSize.height)
            let userEntryView = UserEntryView(viewModel: userEntryViewModel, frame: frame, windowForPicker: pickerWindow)
            
            userEntryView.translatesAutoresizingMaskIntoConstraints = false
            
            targetView.addSubview(userEntryView)
            NSLayoutConstraint.activate([
                userEntryView.leadingAnchor.constraint(equalTo: leadingAnchor),
                userEntryView.topAnchor.constraint(equalTo: topAnchor),
                userEntryView.widthAnchor.constraint(lessThanOrEqualToConstant: entryViewSize.width),
                userEntryView.heightAnchor.constraint(equalToConstant: entryViewSize.height)
                ])
            
            views.append(userEntryView)
            
            if multipleColumns {
                if columnNumber < viewModel.numberOfColumns {
                    x = entryViewSize.width * CGFloat(columnNumber)
                    leadingAnchor = userEntryView.trailingAnchor
                    columnNumber += 1
                }
                else {
                    columnNumber = 1
                    leadingAnchor = targetView.leadingAnchor
                    topAnchor = userEntryView.bottomAnchor
                    x = targetView.frame.minX
                    y = userEntryView.frame.maxY
                }
            }
            else {
                topAnchor = userEntryView.bottomAnchor
                y = userEntryView.frame.maxY
            }
            
            if reversedSortedMutableRowsWithIdentifiers.isEmpty {
                bottomAnchorForLastRow = userEntryView.bottomAnchor
                buttonBarPoint = CGPoint(x: 0, y: CGFloat(views.count) * entryViewSize.height)
                buttonBarHeight = entryViewSize.height
            }
        }
        
        return views
    }
    
    /// Creates a vertical stack of full-width user entry views
    ///
    /// - Parameters:
    ///   - frame: The frame to contain the stack
    ///   - pickerWindow: The target picker window for picker wheel user entry fields
    /// - Returns: Tuple containing the UIStackView with all the fields, and an array of UserEntryViews to grab their states.
    func stackedEntryRows(frame: CGRect, windowForPicker pickerWindow: CGRect?) -> (stackView: UIStackView, entryRows: [UserEntryView]) {
        var reversedSortedEntryRows = self.reversedSortedEntryRows()
        var entryRows = [UserEntryView]()
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        
        while !reversedSortedEntryRows.isEmpty {
            guard let (identifierText, type) = reversedSortedEntryRows.popLast(),
                let placeholder = viewModel.placeholdersWithIdentifiers?[identifierText],
                let description = viewModel.descriptionsWithIdentifiers?[identifierText] else { break }
            let stackedUserEntryViewModel = UserEntryViewModel(type: type, headerText: identifierText, descriptionText: description, placeholderText: placeholder)
            let frame = CGRect(x: 0, y: 0, width: frame.width, height: stackedUserEntryViewModel.stackHeight)
            let userEntryView = UserEntryView(viewModel: stackedUserEntryViewModel, frame: frame, windowForPicker: pickerWindow)
            
            entryRows.append(userEntryView)
            stackView.addArrangedSubview(userEntryView)
            
            userEntryView.heightAnchor.constraint(equalToConstant: stackedUserEntryViewModel.stackHeight).isActive = true
            userEntryView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        }
        
        
        return (stackView: stackView, entryRows: entryRows)
    }
    
    private func reversedSortedEntryRows() -> [(key: Identifier, value: EntryType)] {
        return viewModel.entryTypesForIdentifiers.sorted(by: { this, next in
            guard let thisIndex = viewModel.enforcedOrder.firstIndex(of: this.key),
                let nextIndex = viewModel.enforcedOrder.firstIndex(of: next.key) else {
                    return false
            }
            return thisIndex < nextIndex
        }).reversed().map { $0 }
    }
    
    /// Creates a frame for the user entry views
    ///
    /// - Parameters:
    ///   - frame: A rect representing the space available for the user entry views
    ///   - includeButtonHeight: Whether to include extra space for a row of buttons at the bottom
    /// - Returns: Frame for the user entry views.
    private func userEntrySize(fromView view: UIView, includeButtonHeight: Bool) -> CGSize {
        let numberOfRows = viewModel.numberOfRows + (includeButtonHeight ? 1 : 0)
        let width = view.frame.width / CGFloat(viewModel.numberOfColumns)
        let height = view.frame.height / CGFloat(numberOfRows)
        
        return CGSize(width: width, height: height)
    }
}