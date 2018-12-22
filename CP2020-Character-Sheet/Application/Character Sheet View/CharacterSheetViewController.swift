//
//  CharacterSheetViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class CharacterSheetViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Cyberpunk 2020"
        collectionView.backgroundColor = StyleConstants.Color.dark
        collectionView.register(CharacterDescriptionViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.CharacterDescription.cellReuseID())
        collectionView.register(StatsViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.Stats.cellReuseID())
        collectionView.register(DamageModifierViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.DamageModifier.cellReuseID())
        collectionView.register(DamageViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.Damage.cellReuseID())
        collectionView.register(SkillViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.Skill.cellReuseID())


    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CharacterSheetSections.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = CharacterSheetSections(rawValue: indexPath.row)?.cellReuseID() ?? "" // TODO: Error cell for not finding this.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        // TODO: Yeah this needs cleanup. Maybe a struct or something to handle this. Maybe standardize the setup calls and make a protocol. Or use a layoutsubviews one-time dispatch call inside of each Cell, instead of calling setup externally
        
        if let cell = cell as? DamageViewCell {
            let viewModel = DamageSectionViewModel(startingDamageCellNumber: 1, totalDamage: 40, woundType: .Light, typeRatio: 0.3, cellRatio: 0.3, cellHorizontalPaddingSpace: 0.2, cellVerticalPaddingSpace: 0.2, cellBorderThickness: 1.0, cellCount: 4, stunRatio: 0.4, darkColor: StyleConstants.Color.dark, lightColor: StyleConstants.Color.light)
            let totalDamageController = TotalDamageController(maxDamage: viewModel.totalDamage, delegate: cell)
            cell.setup(with: viewModel, rows: 2, damageController: totalDamageController)
        }
        else if let cell = cell as? DamageModifierViewCell {
            let viewModel = DamageModifierViewModel(cellWidthRatio: 0.25, cellHeightRatio: 1.0, labelHeightRatio: 0.4, paddingRatio: 0.05)
            cell.setup(with: viewModel)
        }
        else if let cell = cell as? StatsViewCell {
            let viewModel = StatsViewCellModel(paddingRatio: 0.0, statsPerRow: 3, statViewWidthRatio: CGFloat(1.0 / 3))
            let statViewModels = Stat.allCases.map { StatViewModel.model(for: $0, baseValue: 10, currentValue: 10) }
            
            cell.setup(with: viewModel, statViewModels: statViewModels)
        }
        else if let cell = cell as? CharacterDescriptionViewCell {
            let userEntryViewModels = [
                UserEntryViewModel(paddingRatio: StyleConstants.SizeConstants.textPaddingRatio,
                                   labelText: CharacterDescriptionConstants.Text.name,
                                   labelWidthRatio: 0.2,
                                   inputMinimumSize: 10.0),
                UserEntryViewModel(paddingRatio: StyleConstants.SizeConstants.textPaddingRatio,
                                   labelText: CharacterDescriptionConstants.Text.handle,
                                   labelWidthRatio: 0.2,
                                   inputMinimumSize: 10.0)
            ]
            let characterClassViewModel = CharacterClassViewModel(paddingRatio: StyleConstants.SizeConstants.textPaddingRatio,
                                                                  classType: CharacterClass.Corporate, classLabelWidthRatio: 0.2)
            cell.setup(with: userEntryViewModels, classViewModel: characterClassViewModel)
        }
        else if let cell = cell as? SkillViewCell {
            let skillViewCellModel = SkillViewCellModel(cellDescriptionLabelWidthRatio: 0.55)
            
            cell.setup(viewModel: skillViewCellModel)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = CharacterSheetSections(rawValue: indexPath.row)?.cellHeight() ?? 160.0
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: height)
    }

}
