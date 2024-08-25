//
//  RevaluationDetailView.swift
//  reRE
//
//  Created by chihoooon on 2024/06/23.
//

import UIKit
import Cosmos
import Then
import SnapKit

final class RevaluationDetailView: UIStackView {
    private lazy var gradeContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var gradeTitleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title01.font
    }
    
    private lazy var gradeLabel = UILabel().then {
        $0.textColor = ColorSet.primary(.orange60).color
        $0.font = FontSet.display01.font
    }
    
    private lazy var ratingView: CosmosView = {
        var settings = CosmosSettings()
        settings.starSize = moderateScale(number: 28)
        settings.starMargin = moderateScale(number: 8)
        settings.fillMode = .half
        settings.filledImage = UIImage(named: "GradedStar")
        settings.emptyImage = UIImage(named: "GradeStar")
        settings.minTouchRating = 0.5
        settings.updateOnTouch = false
        settings.disablePanGestures = true
        
        let view = CosmosView(settings: settings)
        view.rating = 0
        return view
    }()
    
    private lazy var chartContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var chartTitleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title01.font
        $0.text = "최근 5개월 간 평점 추이"
    }
    
    private lazy var chartView = ChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .vertical
        spacing = moderateScale(number: 48)
        
        addViews()
        makeConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addArrangedSubviews([gradeContainerView, chartContainerView])
        gradeContainerView.addSubviews([gradeTitleLabel, gradeLabel, ratingView])
        chartContainerView.addSubviews([chartTitleLabel, chartView])
    }
    
    private func makeConstraints() {
        gradeTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        gradeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(gradeTitleLabel.snp.bottom).offset(moderateScale(number: 24))
        }
        
        ratingView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(gradeLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.bottom.equalToSuperview()
        }
        
        chartTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        chartView.snp.makeConstraints {
            $0.top.equalTo(chartTitleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 170))
        }
    }
    
    func updateGradeView(withModel model: MovieRecentRatingsEntity) {
        if let monthString = model.targetDate.toDate(with: "yyyy-MM")?.dateToString(with: "MM"),
           let month = Int(monthString) {
            gradeTitleLabel.text = "\(month)월 재평가 평점"
        }
        
        gradeLabel.text = "\(model.numStars)"
        ratingView.rating = model.numStars
    }
    
    func updateGradeTrend(ratingsEntity: [MovieRecentRatingsEntity]) {
        chartView.ratings = ratingsEntity
    }
}
