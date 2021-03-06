//
//  CharacterSheetViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class CharacterSheetViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    weak var damageView: DamageViewCell?
    weak var damageModifierView: DamageModifierViewCell?
    weak var statsView: StatsViewCell?
    weak var roleDescriptionView: RoleDescriptionViewCell?
    weak var highlightedSkillView: HighlightedSkillViewCell?
    weak var armorView: ArmorViewCell?
    weak var viewCoordinator: ViewCoordinating?
    
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
        collectionView.register(ArmorViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.Armor.cellReuseID())
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CharacterSheetSections.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = CharacterSheetSections(rawValue: indexPath.row)?.cellReuseID() ?? "" // TODO: Error cell for not finding this.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)

        if let cell = cell as? DamageViewCell {
            let viewModel = DamageSectionViewModel(startingDamageCellNumber: 1, totalDamage: Rules.Damage.maxDamagePoints, woundType: .Light, typeRatio: 0.3, cellRatio: 0.3, cellHorizontalPaddingSpace: 0.2, cellVerticalPaddingSpace: 0.2, cellBorderThickness: 1.0, cellCount: Rules.Damage.pointsPerSection, stunRatio: 0.4, darkColor: StyleConstants.Color.dark, lightColor: StyleConstants.Color.light)
            cell.setup(with: viewModel, rows: 2)
            damageView = cell
        }
        else if let cell = cell as? DamageModifierViewCell {
            let viewModel = DamageModifierViewModel(cellWidthRatio: 0.25, cellHeightRatio: 1.0, labelHeightRatio: 0.4, paddingRatio: 0.05)
            cell.setup(with: viewModel)
            damageModifierView = cell
        }
        else if let cell = cell as? StatsViewCell {
            let viewModel = StatsViewCellModel(paddingRatio: 0.0, statsPerRow: 3, statViewWidthRatio: CGFloat(1.0 / 3))
            let statViewModels = Stat.allCases.map { StatViewModel.model(for: $0, baseValue: 0, currentValue: 0) }
            
            cell.setup(with: viewModel, statViewModels: statViewModels)
            statsView = cell
        }
        else if let cell = cell as? RoleDescriptionViewCell {
            let userEntryViewModels = [
                CharacterDescriptionViewModel(paddingRatio: StyleConstants.Size.textPaddingRatio,
                                              labelText: .Name,
                                              labelWidthRatio: 0.2,
                                              inputMinimumSize: 10.0),
                CharacterDescriptionViewModel(paddingRatio: StyleConstants.Size.textPaddingRatio,
                                              labelText: .Handle,
                                              labelWidthRatio: 0.2,
                                              inputMinimumSize: 10.0)
            ]
            let characterClassViewModel = RoleViewModel(paddingRatio: StyleConstants.Size.textPaddingRatio,
                                                                  roleType: nil, classLabelWidthRatio: 0.2)
            cell.setup(with: userEntryViewModels, classViewModel: characterClassViewModel)
            roleDescriptionView = cell
        }
        else if let cell = cell as? HighlightedSkillViewCell {
            let skillViewCellModel = HighlightedSkillViewCellModel(cellDescriptionLabelWidthRatio: 0.55)
            cell.setup(viewModel: skillViewCellModel)
            highlightedSkillView = cell
        }
        else if let cell = cell as? ArmorViewCell {
            let armorViewCellModel = ArmorViewModel()
            cell.setup(with: armorViewCellModel)
            armorView = cell
        }

        (cell as? ViewCreating)?.viewCoordinator = viewCoordinator
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = CharacterSheetSections(rawValue: indexPath.row)?.cellHeight() ?? 160.0
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: height)
    }
    
}
