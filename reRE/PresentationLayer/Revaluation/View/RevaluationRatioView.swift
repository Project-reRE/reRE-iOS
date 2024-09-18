//
//  RevaluationRatioView.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import UIKit

final class RevaluationRatioView: UIView {
    func drawPiChart(withData percentList: [Double], colorList: [UIColor?]) {
        guard percentList.count == colorList.count else { return }
        
        var startAngle = -Double.pi / 2
        var endAngle: Double = 0
        
        for (index, percent) in percentList.enumerated() {
            endAngle = Double.pi * 2 * percent
            guard endAngle > 0.0 else { continue }
            let center: CGPoint = CGPoint(x: bounds.midX, y: bounds.midY)
            let circlePath = UIBezierPath()
            circlePath.move(to: center)
            
            circlePath.addArc(withCenter: center,
                              radius: moderateScale(number: 95),
                              startAngle: startAngle,
                              endAngle: startAngle + endAngle,
                              clockwise: true)
            
            let circleLayer = CAShapeLayer()
            circleLayer.path = circlePath.cgPath
            
            circleLayer.fillColor = colorList[index]?.cgColor
            circleLayer.strokeColor = colorList[index]?.cgColor
            startAngle += endAngle
            
            layer.addSublayer(circleLayer)
        }
    }
}
