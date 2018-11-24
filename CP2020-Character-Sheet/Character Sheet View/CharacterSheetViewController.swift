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
        collectionView.backgroundColor = .black
        collectionView.register(DamageViewCell.self, forCellWithReuseIdentifier: CharacterSheetSections.Damage.cellReuseID())
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CharacterSheetSections.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = CharacterSheetSections(rawValue: indexPath.row)?.cellReuseID() ?? "" // TODO: Error cell for not finding this.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? DamageViewCell {
            let viewModel = DamageSectionViewModel(startingDamageCellNumber: 1, totalDamage: 40, woundType: .Light, typeRatio: 0.3, cellRatio: 0.3, cellHorizontalPaddingSpace: 0.2, cellVerticalPaddingSpace: 0.2, cellBorderThickness: 1.0, cellCount: 4, stunRatio: 0.4, darkColor: .black, lightColor: .white)
            cell.setup(with: viewModel, rows: 2)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 160)
    }

}
