//
//  PrinterPaperView.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/28/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

/// A view that resembles dot matrix printer paper. Contains a contentView that contains
/// the view contents, and a border of dot matrix printer paper
final class PrinterPaperView: UIView {
    private let viewModel: PrinterPaperViewModel
    private(set) var contentView: UIView

    init(frame: CGRect, viewModel: PrinterPaperViewModel) {
        self.viewModel = viewModel
        self.contentView = UIView()
        super.init(frame: frame)
        clipsToBounds = true
        
        let borderFrameWidth = frame.width * viewModel.printerFeedStripsWidthRatio
        let leftBorderFrame = CGRect(x: frame.minX,
                                     y: frame.minY,
                                     width: borderFrameWidth,
                                     height: frame.height)
        let leftBorder = feedBorder(frame: leftBorderFrame)
        
        addSubview(leftBorder)
        NSLayoutConstraint.activate([
            leftBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftBorder.topAnchor.constraint(equalTo: topAnchor),
            leftBorder.widthAnchor.constraint(equalToConstant: borderFrameWidth),
            leftBorder.heightAnchor.constraint(equalToConstant: frame.height)
            ])
        
        let rightBorderFrame = CGRect(x: frame.maxX - borderFrameWidth,
                                      y: frame.minY,
                                      width: borderFrameWidth,
                                      height: frame.height)
        let rightBorder = feedBorder(frame: rightBorderFrame)
        
        addSubview(rightBorder)
        NSLayoutConstraint.activate([
            rightBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightBorder.topAnchor.constraint(equalTo: topAnchor),
            rightBorder.widthAnchor.constraint(equalToConstant: borderFrameWidth),
            rightBorder.heightAnchor.constraint(equalToConstant: frame.height)
            ])
        let contentViewWidth = frame.width - (borderFrameWidth * 2)
        let contentViewFrame = CGRect(x: frame.minX + borderFrameWidth,
                                      y: frame.minY,
                                      width: contentViewWidth,
                                      height: frame.height)
        let contentView = UIView(frame: contentViewFrame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leftBorder.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.widthAnchor.constraint(equalToConstant: contentViewWidth),
            contentView.heightAnchor.constraint(equalToConstant: frame.height)
            ])
        
        self.contentView = contentView
    }
    
    private func feedBorder(frame: CGRect) -> UIView {
        let container = UIView(frame: frame)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.borderColor = viewModel.darkColor.cgColor
        container.layer.borderWidth = viewModel.lineThickness
        
        let radius = (container.frame.width * viewModel.printerHoleWidthRatio) / 2
        let spacing = container.frame.height * viewModel.printerHoleSpacingRatio
        var circleY = container.frame.minY
        var center: CGPoint {
            return CGPoint(x: container.frame.midX, y: circleY)
        }
        
        /// Continue adding punch holes until we run past the last potentially visible punch hole
        while circleY < container.frame.maxY + radius {
            let circle = makeCircle(center: center, radius: radius)
            
            container.layer.addSublayer(circle)
            circleY = circleY + spacing
        }
        
        return container
    }
    
    private func makeCircle(center: CGPoint, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let layer = CAShapeLayer()
        
        layer.path = path.cgPath
        layer.fillColor = viewModel.lightColor.cgColor
        layer.strokeColor = viewModel.darkColor.cgColor
        layer.lineWidth = viewModel.lineThickness
        
        return layer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}