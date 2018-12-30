//
//  RoleDescriptionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class RoleDescriptionViewCell: UICollectionViewCell, CharacterDescriptionControllerDelegate, UsedOnce {
    
    private (set) var wasSetUp: Bool = false

    private weak var nameLabel: UILabel?
    private weak var handleLabel: UILabel?
    private weak var roleLabel: UILabel?
    private var dataSource: CharacterDescriptionDataSource?
    
    func setup(with userEntryViewModels: [UserEntryViewModel], classViewModel: RoleViewModel) {
        NotificationCenter.default.addObserver(self, selector: #selector(edgerunnerLoaded(notification:)), name: .edgerunnerLoaded, object: nil)
        /// This is only going to have 3 fields for now
        // If this changes in the future, we'll need a viewmodel for this cell.
        let subviewHeight = safeAreaLayoutGuide.layoutFrame.height / 3
        
        var topAnchor = safeAreaLayoutGuide.topAnchor
        let subviewFrame = CGRect(x: safeAreaLayoutGuide.layoutFrame.minX, y: safeAreaLayoutGuide.layoutFrame.minY, width: safeAreaLayoutGuide.layoutFrame.width, height: subviewHeight)
        
        // MARK: Name and Handle fields
        
        userEntryViewModels.enumerated().forEach { index, viewModel in
            let userEntryView = UserEntryView(frame: subviewFrame, viewModel: viewModel)
            contentView.addSubview(userEntryView)
            
            NSLayoutConstraint.activate([
                userEntryView.widthAnchor.constraint(lessThanOrEqualToConstant: subviewFrame.width),
                userEntryView.heightAnchor.constraint(equalToConstant: subviewFrame.height),
                userEntryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                userEntryView.topAnchor.constraint(equalTo: topAnchor)
                ])
            
            topAnchor = userEntryView.bottomAnchor
            
            switch userEntryView.fieldDescription {
            case CharacterDescriptionConstants.Text.name:
                nameLabel = userEntryView.inputField
            case CharacterDescriptionConstants.Text.handle:
                handleLabel = userEntryView.inputField
            case CharacterDescriptionConstants.Text.characterClass:
                roleLabel = userEntryView.inputField
            }
        }
        
        // MARK: Character Class view
        
        let classView = RoleView(frame: subviewFrame, viewModel: classViewModel)
        
        contentView.addSubview(classView)
        NSLayoutConstraint.activate([
            classView.widthAnchor.constraint(lessThanOrEqualToConstant: subviewFrame.width),
            classView.heightAnchor.constraint(equalToConstant: subviewFrame.height),
            classView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            classView.topAnchor.constraint(equalTo: topAnchor)
            ])
        
        roleLabel = classView.classLabel
        setupGestureRecognizers()
        wasSetUp = true
    }
    
    func update(name: String, handle: String) {
        self.nameLabel?.text = name
        self.nameLabel?.fitTextToBounds()
        self.handleLabel?.text = handle
        self.handleLabel?.fitTextToBounds()
    }
    
    func update(role: Role) {
        self.roleLabel?.text = role.rawValue
        self.roleLabel?.fitTextToBounds()
    }
    
    private func setupGestureRecognizers() {
        // Single tap on the entire cell
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(RoleDescriptionViewCell.cellTapped))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTouchesRequired = 1
        contentView.addGestureRecognizer(singleTap)
    }
    
    @objc private func cellTapped() {
        print("Tapped.")
    }
    
    @objc private func edgerunnerLoaded(notification: Notification) {
        guard let model = notification.object as? CharacterDescriptionModel else { return }
        self.dataSource = CharacterDescriptionDataSource(model: model)
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
