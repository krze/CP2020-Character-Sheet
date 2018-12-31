//
//  RoleDescriptionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class RoleDescriptionViewCell: UICollectionViewCell, CharacterDescriptionDataSourceDelegate, UsedOnce {
    
    private (set) var wasSetUp: Bool = false

    private var fields = [RoleFieldLabel: UILabel]()
    private var dataSource: CharacterDescriptionDataSource?
    
    func setup(with descriptionViewModels: [CharacterDescriptionViewModel], classViewModel: RoleViewModel) {
        NotificationCenter.default.addObserver(self, selector: #selector(edgerunnerLoaded(notification:)), name: .edgerunnerLoaded, object: nil)
        /// This is only going to have 3 fields for now
        // If this changes in the future, we'll need a viewmodel for this cell.
        let subviewHeight = safeAreaLayoutGuide.layoutFrame.height / 3
        
        var topAnchor = safeAreaLayoutGuide.topAnchor
        let subviewFrame = CGRect(x: safeAreaLayoutGuide.layoutFrame.minX, y: safeAreaLayoutGuide.layoutFrame.minY, width: safeAreaLayoutGuide.layoutFrame.width, height: subviewHeight)
        
        // MARK: Name and Handle fields
        
        descriptionViewModels.enumerated().forEach { index, viewModel in
            let descriptionView = CharacterDescriptionView(frame: subviewFrame, viewModel: viewModel)
            contentView.addSubview(descriptionView)
            
            NSLayoutConstraint.activate([
                descriptionView.widthAnchor.constraint(lessThanOrEqualToConstant: subviewFrame.width),
                descriptionView.heightAnchor.constraint(equalToConstant: subviewFrame.height),
                descriptionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                descriptionView.topAnchor.constraint(equalTo: topAnchor)
                ])
            
            topAnchor = descriptionView.bottomAnchor
            
            fields[descriptionView.fieldDescription] = descriptionView.inputField
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
        
        fields[classViewModel.classLabel] = classView.classLabel
        setupGestureRecognizers()
        wasSetUp = true
    }
    
    func update(name: String, handle: String) {
        fields[.name]?.text = name
        fields[.name]?.fitTextToBounds()
        
        fields[.handle]?.text = name
        fields[.handle]?.fitTextToBounds()
    }
    
    func update(role: Role) {
        fields[.characterClass]?.text = role.rawValue
        fields[.characterClass]?.fitTextToBounds()
    }
    
    private func setupGestureRecognizers() {
        // Single tap on the entire cell
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(RoleDescriptionViewCell.cellTapped))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTouchesRequired = 1
        contentView.addGestureRecognizer(singleTap)
    }
    
    @objc private func cellTapped() {
        var placeholders = [String: String]()
        fields.forEach { placeholders[$0.key.identifier()] = $0.value.text }
        dataSource?.editorRequested(placeholdersWithIdentifiers: placeholders, entryTypes: RoleFieldLabel.allCases, sourceView: self)
    }
    
    @objc private func edgerunnerLoaded(notification: Notification) {
        guard let model = notification.object as? CharacterDescriptionModel else { return }
        dataSource = CharacterDescriptionDataSource(model: model)
        dataSource?.delegate = self
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
