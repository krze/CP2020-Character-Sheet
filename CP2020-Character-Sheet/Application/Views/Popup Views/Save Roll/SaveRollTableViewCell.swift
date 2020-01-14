//
//  SaveRollTableViewCell.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/14/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

final class SaveRollTableViewCell: UITableViewCell {
    
    weak var delegate: SaveRollDelegate?
    
    private var roll: SaveRoll?
    private var descriptionView: UIView?
    private var button: Button?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    func setup(with saveRoll: SaveRoll) {
        roll = saveRoll

        let textSize = CGSize(width: contentView.frame.width * 0.75, height: contentView.frame.height)
        let descriptionView = CommonEntryConstructor.headerView(size: textSize, text: saveRoll.type.rawValue)
        
        contentView.addSubview(descriptionView)
        
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionView.widthAnchor.constraint(equalToConstant: textSize.width),
            descriptionView.heightAnchor.constraint(equalToConstant: textSize.height)
        ])
        
        let buttonSize = CGSize(width: contentView.frame.width * 0.25, height: contentView.frame.height)
        let buttonFrame = CGRect(origin: .zero, size: buttonSize)
        let buttonModel = ButtonModel(frame: buttonFrame)
        let button = Button(model: buttonModel)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.widthAnchor.constraint(equalToConstant: buttonSize.width),
            button.heightAnchor.constraint(equalToConstant: buttonSize.height)
        ])
        
        self.descriptionView = descriptionView
        self.button = button
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        roll = nil
        descriptionView = nil
        button = nil
    }
    
    @objc private func buttonTapped() {
        delegate?.rollPerformed(wasSuccessful: roll?.resolve() ?? false)
    }

}
