//
//  CharacterDescriptionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class CharacterDescriptionViewCell: UICollectionViewCell {
    
    func setup(with userEntryViewModels: [UserEntryViewModel], classViewModel: CharacterClassViewModel) {
        /// This is only going to have 3 fields for now
        // If this changes in the future, we'll need a viewmodel for this cell.
        let subviewHeight = safeAreaLayoutGuide.layoutFrame.height / 3
        
        var topAnchor = safeAreaLayoutGuide.topAnchor
        let subviewFrame = CGRect(x: safeAreaLayoutGuide.layoutFrame.minX, y: safeAreaLayoutGuide.layoutFrame.minY, width: safeAreaLayoutGuide.layoutFrame.width, height: subviewHeight)
        
        // MARK: User Entry views
        
        userEntryViewModels.enumerated().forEach { index, viewModel in
            let userEntryView = UserEntryView(frame: subviewFrame, viewModel: viewModel)
            addSubview(userEntryView)
            
            NSLayoutConstraint.activate([
                userEntryView.widthAnchor.constraint(lessThanOrEqualToConstant: subviewFrame.width),
                userEntryView.heightAnchor.constraint(equalToConstant: subviewFrame.height),
                userEntryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                userEntryView.topAnchor.constraint(equalTo: topAnchor)
                ])
            
            topAnchor = userEntryView.bottomAnchor
        }
        
        // MARK: Character Class view
        
        let classView = CharacterClassView(frame: subviewFrame, viewModel: classViewModel)
        
        addSubview(classView)
        NSLayoutConstraint.activate([
            classView.widthAnchor.constraint(lessThanOrEqualToConstant: subviewFrame.width),
            classView.heightAnchor.constraint(equalToConstant: subviewFrame.height),
            classView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            classView.topAnchor.constraint(equalTo: topAnchor)
            ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = StyleConstants.Color.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This initializer is not supported.")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("Interface Builder is not supported!")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // TODO: Test cell re-use and see if it needs anything here
    }
    
}
