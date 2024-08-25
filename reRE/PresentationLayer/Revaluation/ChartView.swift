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
        
        layer.masksToBounds = true
        layer.cornerRadius = moderateScale(number: 8)
        backgroundColor = ColorSet.gray(.gray20).color
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
            circleLayer.fillColor = ColorSet.primary(.orange60).color?.cgColor
            circleLayer.strokeColor = ColorSet.primary(.orange60).color?.cgColor
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
                lineLayer.strokeColor = ColorSet.primary(.orange60).color?.cgColor
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.lineWidth = 1
                layer.addSublayer(lineLayer)
            }
            
            let monthLabel = UILabel()
            
            if let monthString = rating.targetDate.toDate(with: "yyyy-MM")?.dateToString(with: "MM"),
               let month = Int(monthString) {
                monthLabel.text = "\(month)월"
            }
            
            monthLabel.textColor = ColorSet.gray(.gray60).color
            monthLabel.font = FontSet.label02.font
            addSubview(monthLabel)
            
            monthLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(minRatingPosY + moderateScale(number: 4))
                $0.centerX.equalToSuperview().offset(chartMargin * CGFloat(index - 2))
            }
            
            let ratingLabel = UILabel()
            ratingLabel.text = "\(rating.numStars)"
            ratingLabel.textColor = ColorSet.primary(.orange60).color
            ratingLabel.font = FontSet.body04.font
            addSubview(ratingLabel)
            
            ratingLabel.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(bounds.height - posY + moderateScale(number: 3))
                $0.centerX.equalToSuperview().offset(chartMargin * CGFloat(index - 2))
            }
        }
        
        backgroundPath.addLine(to: CGPoint(x: bounds.maxX - moderateScale(number: 45), y: minRatingPosY))
        backgroundPath.close()
        
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.fillColor = ColorSet.primary(.orange50).color?.withAlphaComponent(0.4).cgColor
        backgroundLayer.strokeColor = UIColor.clear.cgColor
    }
    
    override func draw(_ rect: CGRect) {
        let sideMargin: CGFloat = moderateScale(number: 16)
        
        for index in 0..<7 {
            let posY: CGFloat = rect.maxY - moderateScale(number: 34) - (CGFloat(index) * moderateScale(number: 20))
            let lineLayer = CAShapeLayer()
            
            if index != 0 {
                lineLayer.lineDashPattern = [4, 4]
                lineLayer.strokeColor = ColorSet.gray(.gray30).color?.withAlphaComponent(0.6).cgColor
            } else {
                lineLayer.lineDashPattern = nil
                lineLayer.strokeColor = ColorSet.gray(.gray30).color?.cgColor
            }
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: sideMargin, y: posY))
            path.addLine(to: CGPoint(x: rect.maxX - sideMargin, y: posY))
            
            lineLayer.path = path.cgPath
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.lineWidth = moderateScale(number: 1)
            
            layer.addSublayer(lineLayer)
        }
    }
}
