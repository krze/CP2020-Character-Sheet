//
//  DamageViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class DamageViewCell: UICollectionViewCell, TotalDamageDataSourceDelegate, UsedOnce {
    private (set) var wasSetUp: Bool = false
    
    private var dataSource: TotalDamageDataSource?

    private var totalDamage: Int?
    private(set) var damageCells = [DamageCell]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
    }
    
    /// Sets up the view by supplying a view model object
    ///
    /// - Parameters:
    ///   - viewModel: The initial DamageSectionViewModel
    ///   - rows: The number of rows
    func setup(with damageViewModel: DamageSectionViewModel, rows: Int) {
        if wasSetUp {
            dataSource?.refreshData()
            return
        }
        
        self.totalDamage = damageViewModel.totalDamage
        var viewModel = damageViewModel
        
        // For iterating on the next view model.
        var wounds = WoundType.allCases.reversed().map { $0 }
        var woundType = wounds.popLast() ?? .Light
        
        let sectionWidthMultiplier = CGFloat(1.0 / ((CGFloat(viewModel.totalDamage) / CGFloat(viewModel.damageCellCount)) / CGFloat(rows)))
        let sectionHeightMultiplier = CGFloat(1.0 / CGFloat(rows))
        
        // The first cell will start with the top left corner, so leading/top will be the edge
        // of the view. These values will be replaced with the trailing anchor of the cell when
        // the construction is finished
        var leadingAnchor = self.contentView.safeAreaLayoutGuide.leadingAnchor
        var topAnchor = self.contentView.safeAreaLayoutGuide.topAnchor
        
        var nextViewNumber = 1
        var currentRow = 1
        let viewsPerRow = (viewModel.totalDamage / viewModel.damageCellCount) / rows
        var frame = CGRect(x: contentView.safeAreaLayoutGuide.layoutFrame.minX, y: contentView.safeAreaLayoutGuide.layoutFrame.minY, width: contentView.safeAreaLayoutGuide.layoutFrame.width * sectionWidthMultiplier, height: contentView.safeAreaLayoutGuide.layoutFrame.height * sectionHeightMultiplier)
        while viewModel.startingDamageCellNumber < viewModel.totalDamage {
            let view = DamageSectionView(with: viewModel, frame: frame)
            self.damageCells.append(contentsOf: view.damageCells)
            contentView.addSubview(view)

            // MARK: Damage cell layout
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: sectionWidthMultiplier),
                view.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: sectionHeightMultiplier)
                ])
            
            // Prep for the next view's relevant properties
            nextViewNumber += 1
            
            // Set the next anchors
            leadingAnchor = view.trailingAnchor
            var newRowX: CGFloat?
            var newRowY: CGFloat?
            // Only update the topAnchor if we've gone down a row
            if nextViewNumber > viewsPerRow * currentRow {
                newRowX = contentView.safeAreaLayoutGuide.layoutFrame.minX
                newRowY = contentView.safeAreaLayoutGuide.layoutFrame.minY + (frame.height * CGFloat(currentRow))
                currentRow += 1
                leadingAnchor = contentView.safeAreaLayoutGuide.leadingAnchor
                topAnchor = view.bottomAnchor
            }
            else {
                leadingAnchor = view.trailingAnchor
            }
            
            frame = CGRect(x: newRowX ?? frame.minX + frame.width, y: newRowY ?? frame.minY, width: frame.width, height: frame.height)
            // The last wound type should be mortal, and will continue to be so until all views are constructed.
            // Only update the type if there's another wound type in the list.
            if let nextWoundType = wounds.popLast() {
                woundType = nextWoundType
            }
            
            viewModel = viewModel.constructNextModel(for: woundType)
        }
        
        // This is in place to ensure we never misalign these totals
        assert(damageCells.count == totalDamage ?? 0, "Cell count an unexpected amount.")
        setupGestureRecognizers()
        wasSetUp = true
    }
    
    func updateCells(to newDamage: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard newDamage > 0 else {
                self.damageCells.forEach { $0.markAsUndamaged() }
                return
            }
            
            var currentDamage: Int {
                return self.damageCells.filter({ $0.isDamaged }).count
            }
            let currentDamageIndex = currentDamage - 1
            let destinationIndex = newDamage - 1
            
            var increasing = true
            var next = 0

            if currentDamageIndex <= destinationIndex {
                next = currentDamageIndex + 1
            }
            else {
                increasing = false
                next = currentDamageIndex
            }
            
            // Do nothing if we can't apply the damage
            guard self.damageCells.indices.contains(next) else {
                return
            }
        
            while currentDamage != newDamage {
                let color: UIColor = increasing ? StyleConstants.Color.red : StyleConstants.Color.light
                self.damageCells[next].backgroundColor = color
                
                if increasing {
                    self.damageCells[next].markAsDamaged()
                    next += 1
                }
                else {
                    self.damageCells[next].markAsUndamaged()
                    next -= 1
                }
            }
        }
    }
    
    func update(dataSource: TotalDamageDataSource) {
        self.dataSource = dataSource
        self.dataSource?.delegate = self
    }
    
    // MARK: Gesture Recognition and actions
    
    private func setupGestureRecognizers() {
        // Single tap
        let openStatusTap = UITapGestureRecognizer(target: self, action: #selector(DamageViewCell.cellWasTapped))
        openStatusTap.cancelsTouchesInView = false
        openStatusTap.numberOfTouchesRequired = 1
        contentView.addGestureRecognizer(openStatusTap)
        
        // Long Press
        let jumpToNewDamagePress = UILongPressGestureRecognizer(target: self, action: #selector(DamageViewCell.cellWasLongPressed))
        jumpToNewDamagePress.cancelsTouchesInView = false
        jumpToNewDamagePress.numberOfTouchesRequired = 1
        contentView.addGestureRecognizer(jumpToNewDamagePress)
    }
    
    @objc private func cellWasTapped() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let model = EditorCollectionViewModel.incomingDamage()
            let viewController = EditorCollectionViewController(with: model)
            viewController.delegate = self.dataSource
            NotificationCenter.default.post(name: .showEditor, object: viewController)
        }
    }
    
    @objc private func cellWasLongPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .ended else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let model = EditorCollectionViewModel.incomingDamage()
            let viewController = EditorCollectionViewController(with: model)
            viewController.delegate = self.dataSource
            NotificationCenter.default.post(name: .showEditor, object: viewController)
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
    
    private func alert(error: Error) {
        let alert = UIAlertController(title: "Unable to update damage:", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        NotificationCenter.default.post(name: .showHelpTextAlert, object: alert)
    }
    
}
