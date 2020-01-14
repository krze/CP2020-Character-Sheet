//
//  SaveRollView.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/13/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

struct SaveRollViewModel {
    
    let rolls: [SaveRoll]
    let descriptionHeight: CGFloat
    
}

final class SaveRollView: UIView {
    private let manager = SaveRollViewManager()
    
    func setup(with viewModel: SaveRollViewModel) {
        manager.appendRolls(viewModel.rolls)
        let tableView = UITableView()
        
        tableView.delegate = manager
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: widthAnchor),
            tableView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        // NEXT: Replace this all with tableviewcells in the SaveRollTableViewManager

        let descriptionLabel = UILabel()
        
        descriptionLabel.font = StyleConstants.Font.defaultBold
        descriptionLabel.text = SaveRollStrings.saveRollViewDescription
                
        
        viewModel.rolls.forEach { roll in
            let rowView = UIStackView()
            rowView.axis = .horizontal
            rowView.alignment = .center
    
            
            let label = UILabel()
            label.font = StyleConstants.Font.defaultFont
            label.text = roll.type.rawValue
            
            rowView.addArrangedSubview(label)
            
            let dummyMiddleView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 500, height: 2)))
            rowView.addArrangedSubview(dummyMiddleView)
            
            // Placeholder button
            let rollButton = UIButton()
            rollButton.titleLabel?.font = StyleConstants.Font.defaultBold
            rollButton.setTitleColor(StyleConstants.Color.blue, for: .normal)
            rollButton.setTitleColor(StyleConstants.Color.gray, for: .selected)
            rollButton.titleLabel?.text = "Roll"
            
            // NEXT: Make the result of the roll change the row to a pass or fail state
            // AFTER: Callback delegate, model will need a state to track how many save rolls it needs to perform,
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
