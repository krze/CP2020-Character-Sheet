//
//  ColumnTableViewHeader.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

struct ColumnTableViewModel: MarginCreator {
    
    let name: String
    let firstColumn: String
    let secondColumn: String
    let thirdColumn: String
    
    let columnLabelWidthRatio = CGFloat(0.15)
    let paddingRatio: CGFloat = 0.02
    let darkColor = StyleConstants.Color.dark
    let lightColor = StyleConstants.Color.light
    let headerFont = StyleConstants.Font.defaultBold
    let columnLabelFont = StyleConstants.Font.defaultItalic
    let columnLabelMaxTextSize = CGFloat(16)

}

final class ColumnTableViewHeader: UIView {
    
    init(viewModel: ColumnTableViewModel, frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = viewModel.darkColor
        directionalLayoutMargins = viewModel.createInsets(with: frame)
        let labelFrame = CGRect(x: frame.minX,
                                y: frame.minY,
                                width: frame.width - directionalLayoutMargins.leading - directionalLayoutMargins.trailing,
                                height: frame.height - directionalLayoutMargins.top - directionalLayoutMargins.bottom)
        let label = CommonViews.headerLabel(frame: labelFrame)
        label.font = viewModel.headerFont
        label.backgroundColor = viewModel.darkColor
        label.textColor = viewModel.lightColor
        label.text = viewModel.name
      
        addSubview(label)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: labelFrame.width),
            label.heightAnchor.constraint(equalToConstant: labelFrame.height),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
          ])
      
        let headerFrame = frame
        var trailingAnchor = self.trailingAnchor
        let columnLabelTexts = [viewModel.thirdColumn,
                              viewModel.secondColumn,
                              viewModel.firstColumn]
      
        columnLabelTexts.enumerated().forEach { index, text in
            let width = headerFrame.width * viewModel.columnLabelWidthRatio
            let frame = CGRect(x: headerFrame.maxX - (width * CGFloat(index)),
                               y: headerFrame.minY,
                               width: width,
                               height: headerFrame.height)
            let margins = viewModel.createInsets(with: frame)
            let backgroundColor = StyleConstants.Color.dark
          
            func columnLabel(frame: CGRect) -> UILabel {
                let label = CommonViews.headerLabel(frame: frame)
                label.font = viewModel.columnLabelFont?.withSize(viewModel.columnLabelMaxTextSize)
                label.backgroundColor = viewModel.darkColor
                label.textColor = viewModel.lightColor
                label.text = text
                label.backgroundColor = backgroundColor
                label.textAlignment = .center
                return label
            }
          
            let columnView = UILabel.container(frame: frame, margins: margins, backgroundColor: backgroundColor, borderColor: nil, borderWidth: nil, labelMaker: columnLabel)
          
            addSubview(columnView.container)
            
            NSLayoutConstraint.activate([
                columnView.container.topAnchor.constraint(equalTo: topAnchor),
                columnView.container.trailingAnchor.constraint(equalTo: trailingAnchor),
                columnView.container.widthAnchor.constraint(equalToConstant: frame.width),
                columnView.container.heightAnchor.constraint(equalToConstant: frame.height)
              ])
            columnView.label.text = columnView.label.text?.uppercased()
            columnView.label.fitTextToBounds()
            trailingAnchor = columnView.container.leadingAnchor
        }
        label.text = label.text?.uppercased()
        label.fitTextToBounds()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
