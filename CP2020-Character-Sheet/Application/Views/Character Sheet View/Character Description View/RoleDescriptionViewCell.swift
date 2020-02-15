//
//  RoleDescriptionViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/24/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class RoleDescriptionViewCell: UICollectionViewCell, CharacterDescriptionDataSourceDelegate, UsedOnce, ViewCreating {
    
    weak var viewCoordinator: ViewCoordinating?
    
    private (set) var wasSetUp: Bool = false

    private var fields = [RoleFieldLabel: UILabel]()
    private(set) var dataSource: CharacterDescriptionDataSource?
    
    func setup(with descriptionViewModels: [CharacterDescriptionViewModel], classViewModel: RoleViewModel) {
        if wasSetUp {
            dataSource?.refreshData()
            return
        }
        
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
        fields[.Name]?.text = name
        fields[.Name]?.fitTextToBounds()
        
        fields[.Handle]?.text = handle
        fields[.Handle]?.fitTextToBounds()
    }
    
    func update(role: Role) {
        fields[.CharacterRole]?.text = role.rawValue
        fields[.CharacterRole]?.fitTextToBounds()
    }
    
    func update(dataSource: CharacterDescriptionDataSource) {
        self.dataSource = dataSource
        self.dataSource?.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = StyleConstants.Color.gray
    }
    
    private func setupGestureRecognizers() {
        // Single tap on the entire cell
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(RoleDescriptionViewCell.cellTapped))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTouchesRequired = 1
        contentView.addGestureRecognizer(singleTap)
    }
    
    @objc private func cellTapped() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let role = Role(rawValue: self.fields[.CharacterRole]?.text ?? "")
            let model = EditorCollectionViewModel.model(with: role, name: self.fields[.Name]?.text ?? "", handle: self.fields[.Handle]?.text ?? "")
            let viewController = EditorCollectionViewController(with: model)
            
            viewController.delegate = self.dataSource
            self.viewCoordinator?.viewControllerNeedsPresentation(vc: viewController)
        }
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
