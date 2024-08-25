//
//  ChartView.swift
//  reRE
//
//  Created by 강치훈 on 8/18/24.
//

import UIKit
import SnapKit

final class ChartView: UIView {
    private let numberOfLines: CGFloat = 6
    
    var ratings: [MovieRecentRatingsEntity]? {
        didSet {
            drawChart()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawChart() {
        guard let ratings = ratings else { return }
        
        let chartWidth: CGFloat = bounds.width - moderateScale(number: 45 * 2)
        let chartMargin: CGFloat = chartWidth / 4
        
        let maxRatingPosY: CGFloat = bounds.maxY - moderateScale(number: 34) - (moderateScale(number: 20) * (numberOfLines - 1))
        let minRatingPosY: CGFloat = bounds.maxY - moderateScale(number: 34)
        let chartHeight: CGFloat = moderateScale(number: 20) * (numberOfLines - 1)
        
        let backgroundLayer = CAShapeLayer()
        layer.addSublayer(backgroundLayer)
        let backgroundPath = UIBezierPath()
        backgroundPath.move(to: CGPoint(x: moderateScale(number: 45), y: minRatingPosY))
        
        for (index, rating) in ratings.enumerated() {
            let posX: CGFloat = moderateScale(number: 45) + chartMargin * CGFloat(index)
            let posY: CGFloat = chartHeight - ((chartHeight * rating.numStars) / 5) + maxRatingPosY
            
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: posX, y: posY),
                                          radius: moderateScale(number: 3),
                                          startAngle: 0,
                                          endAngle: Double.pi * 2,
                                          clockwise: true)
            let circleLayer = CAShapeLayer()
            circleLayer.path = circlePath.cgPath
            circleLayer.fillColor = UIColor.red.cgColor
            circleLayer.strokeColor = UIColor.red.cgColor
            circleLayer.lineWidth = 1
            
            layer.addSublayer(circleLayer)
            
            backgroundPath.addLine(to: CGPoint(x: posX, y: posY))
            
            if index < ratings.count - 1 {
                let nextRating: Double = ratings[index + 1].numStars
                let nextPosX: CGFloat = moderateScale(number: 45) + chartMargin * CGFloat(index + 1)
                let nextPosY: CGFloat = chartHeight - ((chartHeight * nextRating) / 5) + maxRatingPosY
                
                let lineLayer = CAShapeLayer()
                let linePath = UIBezierPath()
                linePath.move(to: CGPoint(x: posX, y: posY))
                linePath.addLine(to: CGPoint(x: nextPosX, y: nextPosY))
                
                lineLayer.path = linePath.cgPath
                lineLayer.strokeColor = UIColor.red.cgColor
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.lineWidth = 1
                layer.addSublayer(lineLayer)
            }
            
            let monthLabel = UILabel()
            monthLabel.text = rating.targetDate
            monthLabel.textColor = .red
            addSubview(monthLabel)
            
            monthLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(minRatingPosY + moderateScale(number: 4))
                $0.centerX.equalToSuperview().offset(chartMargin * CGFloat(index - 2))
            }
            
            let ratingLabel = UILabel()
            ratingLabel.text = "\(rating.numStars)"
            ratingLabel.textColor = .red
            addSubview(ratingLabel)
            
            ratingLabel.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(bounds.height - posY + moderateScale(number: 3))
                $0.centerX.equalToSuperview().offset(chartMargin * CGFloat(index - 2))
            }
        }
        
        backgroundPath.addLine(to: CGPoint(x: bounds.maxX - moderateScale(number: 45), y: minRatingPosY))
        backgroundPath.close()
        
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.fillColor = UIColor.blue.withAlphaComponent(0.4).cgColor
        backgroundLayer.strokeColor = UIColor.clear.cgColor
    }
    
    override func draw(_ rect: CGRect) {
        let sideMargin: CGFloat = moderateScale(number: 16)
        
        for index in 0..<7 {
            let posY: CGFloat = rect.maxY - moderateScale(number: 34) - (CGFloat(index) * moderateScale(number: 20))
            let lineLayer = CAShapeLayer()
            
            if index != 0 {
                lineLayer.lineDashPattern = [4, 4]
            } else {
                lineLayer.lineDashPattern = nil
            }
            
            lineLayer.strokeColor = UIColor.green.cgColor
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: sideMargin, y: posY))
            path.addLine(to: CGPoint(x: rect.maxX - sideMargin, y: posY))
            
            lineLayer.path = path.cgPath
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.lineWidth = moderateScale(number: 1)
            
            layer.addSublayer(lineLayer)
        }
    }
    
    private func drawBaseLines() {
        let sideMargin: CGFloat = moderateScale(number: 16)
        
        for index in 0..<7 {
            let posY: CGFloat = bounds.maxY - moderateScale(number: 34) - (CGFloat(index) * moderateScale(number: 20))
            let lineLayer = CAShapeLayer()
            
            if index != 0 {
                lineLayer.lineDashPattern = [4, 4]
            } else {
                lineLayer.lineDashPattern = nil
            }
            
            lineLayer.strokeColor = UIColor.green.cgColor
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: sideMargin, y: posY))
            path.addLine(to: CGPoint(x: bounds.maxX - sideMargin, y: posY))
            
            lineLayer.path = path.cgPath
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.lineWidth = moderateScale(number: 1)
            
            layer.addSublayer(lineLayer)
        }
    }
}
