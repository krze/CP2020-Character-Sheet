//
//  CharacterSheetViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class CharacterSheetViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    weak var coordinator: CharacterSheetDataSourceCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Character Sheet"
        collectionView.backgroundColor = StyleConstants.Color.dark
        collectionView.register(RoleDescriptionViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.CharacterDescription.cellReuseID())
        collectionView.register(StatsViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.Stats.cellReuseID())
        collectionView.register(DamageModifierViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.DamageModifier.cellReuseID())
        collectionView.register(DamageViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.Damage.cellReuseID())
        collectionView.register(HighlightedSkillViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.Skill.cellReuseID())


    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CharacterSheetSections.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = CharacterSheetSections(rawValue: indexPath.row)?.cellReuseID() ?? "" // TODO: Error cell for not finding this.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        // TODO: This needs cleanup. Maybe a struct or something to handle this.
        // Maybe standardize the setup calls and make a protocol.
        // Or use a layoutsubviews one-time dispatch call inside of each Cell, instead of calling setup externally
        
        if let cell = cell as? DamageViewCell, !cell.wasSetUp {
            let viewModel = DamageSectionViewModel(startingDamageCellNumber: 1, totalDamage: 40, woundType: .Light, typeRatio: 0.3, cellRatio: 0.3, cellHorizontalPaddingSpace: 0.2, cellVerticalPaddingSpace: 0.2, cellBorderThickness: 1.0, cellCount: 4, stunRatio: 0.4, darkColor: StyleConstants.Color.dark, lightColor: StyleConstants.Color.light)
            let totalDamageDataSource = TotalDamageDataSource(maxDamage: viewModel.totalDamage)
            totalDamageDataSource.delegate = cell
            
            cell.setup(with: viewModel, rows: 2, damageController: totalDamageDataSource)
            coordinator?.totalDamageDataSource = totalDamageDataSource
        }
        else if let cell = cell as? DamageModifierViewCell, !cell.wasSetUp {
            let viewModel = DamageModifierViewModel(cellWidthRatio: 0.25, cellHeightRatio: 1.0, labelHeightRatio: 0.4, paddingRatio: 0.05)
            cell.setup(with: viewModel)
        }
        else if let cell = cell as? StatsViewCell, !cell.wasSetUp {
            let viewModel = StatsViewCellModel(paddingRatio: 0.0, statsPerRow: 3, statViewWidthRatio: CGFloat(1.0 / 3))
            let statViewModels = Stat.allCases.map { StatViewModel.model(for: $0, baseValue: 0, currentValue: 0) }
            
            cell.setup(with: viewModel, statViewModels: statViewModels)
        }
        else if let cell = cell as? RoleDescriptionViewCell, !cell.wasSetUp {
            let userEntryViewModels = [
                CharacterDescriptionViewModel(paddingRatio: StyleConstants.SizeConstants.textPaddingRatio,
                                              labelText: .Name,
                                              labelWidthRatio: 0.2,
                                              inputMinimumSize: 10.0),
                CharacterDescriptionViewModel(paddingRatio: StyleConstants.SizeConstants.textPaddingRatio,
                                              labelText: .Handle,
                                              labelWidthRatio: 0.2,
                                              inputMinimumSize: 10.0)
            ]
            let characterClassViewModel = RoleViewModel(paddingRatio: StyleConstants.SizeConstants.textPaddingRatio,
                                                                  roleType: nil, classLabelWidthRatio: 0.2)
            cell.setup(with: userEntryViewModels, classViewModel: characterClassViewModel)
        }
        else if let cell = cell as? HighlightedSkillViewCell, !cell.wasSetUp {
            let skillViewCellModel = HighlightedSkillViewCellModel(cellDescriptionLabelWidthRatio: 0.55)
            let dataSource = HighlightedSkillViewCellDataSource()
            
            cell.setup(viewModel: skillViewCellModel, dataSource: dataSource)
            coordinator?.highlightedSkillViewCellDataSource = dataSource
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = CharacterSheetSections(rawValue: indexPath.row)?.cellHeight() ?? 160.0
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: height)
    }
    
}
