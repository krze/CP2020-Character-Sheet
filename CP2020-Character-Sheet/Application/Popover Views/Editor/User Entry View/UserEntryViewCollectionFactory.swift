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
    let viewModel: PopoverEditorViewModel // Eventually this will have to be more generic, maybe make the necessary items a protocol.

    /// Adjusts the frame given to the minimum height required to hold a collection of all the user
    /// entry views required by the viewModel.
    ///
    /// - Parameter frame: Target frame
    /// - Returns: Adjusted frame for the minimum required height to hold all UserEntryViews
    func minimumSizedFrameForCollection(from frame: CGRect) -> CGRect {
        return CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: viewModel.minimumHeightForAllRows)
    }
    
    /// Adds the UserEntryViews to the targetView provided.
    ///
    /// - Parameter targetView: The view to which you want to add a collection of UserEntryViews
    /// - Parameter windowForPicker: The frame representing the window in case a picker needs to be presented.
    /// - Returns: An array of created UserEntryViews
    func addUserEntryViews(to targetView: UIView, windowForPicker pickerWindow: CGRect?) -> [UserEntryView] {
        let width = targetView.frame.width / CGFloat(viewModel.numberOfColumns)
        let height = targetView.frame.height / CGFloat(viewModel.numberOfRows)
        
        let multipleColumns = viewModel.numberOfColumns > 1
        
        var reversedSortedMutableRowsWithIdentifiers = viewModel.rowsWithIdentifiers.sorted(by: { this, next in
            guard let thisIndex = viewModel.enforcedOrder.firstIndex(of: this.key),
                let nextIndex = viewModel.enforcedOrder.firstIndex(of: next.key) else {
                    return false
            }
            return thisIndex < nextIndex
        }).reversed().map { $0 }
        
        var views = [UserEntryView]()
        var leadingAnchor = targetView.leadingAnchor
        var topAnchor = targetView.topAnchor
        var x = targetView.frame.minX
        var y = targetView.frame.minY
        var columnNumber = 1
        
        while !reversedSortedMutableRowsWithIdentifiers.isEmpty {
            guard let (labelText, type) = reversedSortedMutableRowsWithIdentifiers.popLast() else { break }
            
            let userEntryViewModel = UserEntryViewModel(type: type,
                                                        labelText: labelText,
                                                        labelWidthRatio: viewModel.labelWidthRatio)
            let frame = CGRect(x: x, y: y, width: width, height: height)
            let userEntryView = UserEntryView(viewModel: userEntryViewModel, frame: frame, windowForPicker: pickerWindow)
            
            userEntryView.translatesAutoresizingMaskIntoConstraints = false
            
            targetView.addSubview(userEntryView)
            NSLayoutConstraint.activate([
                userEntryView.leadingAnchor.constraint(equalTo: leadingAnchor),
                userEntryView.topAnchor.constraint(equalTo: topAnchor),
                userEntryView.widthAnchor.constraint(lessThanOrEqualToConstant: width),
                userEntryView.heightAnchor.constraint(equalToConstant: height)
                ])
            
            views.append(userEntryView)
            
            if multipleColumns {
                if columnNumber < viewModel.numberOfColumns {
                    x = width * CGFloat(columnNumber)
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
        }
        
        return views
    }
}
