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
        settings.fillMode = .precise
        settings.filledImage = UIImage(named: "GradedStar")
        settings.emptyImage = UIImage(named: "GradeStar")
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
    
    private lazy var specialPointContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var specialPointTitleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title01.font
        $0.text = "주목 포인트는?"
    }
    
    private lazy var specialPointView = RevaluationSpecialPointView()
    
    private lazy var showMovieButton = TouchableLabel().then {
        $0.text = "영화 보러가기"
        $0.font = FontSet.button02.font
        $0.textColor = ColorSet.gray(.white).color
        $0.textAlignment = .center
        $0.backgroundColor = ColorSet.secondary(.olive40).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var pastFeelingsContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var pastFeelingsTitleLabel = UILabel().then {
        $0.text = "개봉 당시, 이 영화에 대해서 사람들은요"
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title01.font
    }
    
    private lazy var pastFeelingsView = RevaluationFeelingsView()
    
    private lazy var currentFeelingsContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var currentFeelingsTitleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title01.font
    }
    
    private lazy var currentFeelingsView = RevaluationFeelingsView()
    
    private lazy var dividerView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray30).color
    }
    
    private lazy var revaluationParticipantsContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var revaluationParticipantsTitleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title01.font
    }
    
    private lazy var participantsCountView = RevaluationParticipantCountView()
    
    private lazy var genderRatioView = RevaluationGenderRatioView()
    
    private lazy var ageRatioView = RevaluationAgeRatioView()
    
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
        addArrangedSubviews([gradeContainerView, chartContainerView, specialPointContainerView, pastFeelingsContainerView,
                             currentFeelingsContainerView, dividerView, revaluationParticipantsContainerView])
        
        gradeContainerView.addSubviews([gradeTitleLabel, gradeLabel, ratingView])
        chartContainerView.addSubviews([chartTitleLabel, chartView])
        specialPointContainerView.addSubviews([specialPointTitleLabel, specialPointView, showMovieButton])
        pastFeelingsContainerView.addSubviews([pastFeelingsTitleLabel, pastFeelingsView])
        currentFeelingsContainerView.addSubviews([currentFeelingsTitleLabel, currentFeelingsView])
        revaluationParticipantsContainerView.addSubviews([revaluationParticipantsTitleLabel, participantsCountView,
                                                          genderRatioView, ageRatioView])
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
        
        specialPointTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        specialPointView.snp.makeConstraints {
            $0.top.equalTo(specialPointTitleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview()
        }
        
        showMovieButton.snp.makeConstraints {
            $0.top.equalTo(specialPointView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 44))
        }
        
        pastFeelingsTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        pastFeelingsView.snp.makeConstraints {
            $0.top.equalTo(pastFeelingsTitleLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.centerX.bottom.equalToSuperview()
        }
        
        currentFeelingsTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        currentFeelingsView.snp.makeConstraints {
            $0.top.equalTo(currentFeelingsTitleLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.centerX.bottom.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 1))
        }
        
        revaluationParticipantsTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        participantsCountView.snp.makeConstraints {
            $0.top.equalTo(revaluationParticipantsTitleLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.centerX.equalToSuperview()
        }
        
        genderRatioView.snp.makeConstraints {
            $0.top.equalTo(participantsCountView.snp.bottom).offset(moderateScale(number: 48))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        ageRatioView.snp.makeConstraints {
            $0.top.equalTo(genderRatioView.snp.bottom).offset(moderateScale(number: 48))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.bottom.equalToSuperview()
        }
    }
    
    func updateGradeView(withModel model: MovieRecentRatingsEntity) {
        if let monthString = model.currentDate.toDate(with: "yyyy-MM")?.dateToString(with: "MM"),
           let month = Int(monthString) {
            gradeTitleLabel.text = "\(month)월 재평가 평점"
            currentFeelingsTitleLabel.text = "\(month)월에 이 영화에 대해서 사람들은요"
            revaluationParticipantsTitleLabel.text = "\(month)월, 재평가에 참여한 사람들"
        }
        
        gradeLabel.text = "\(model.numStars)"
        
        if let numStars = Double(model.numStars) {
            ratingView.rating = numStars
        }
    }
    
    func updateGradeTrend(ratingsEntity: [MovieRecentRatingsEntity]) {
        chartView.ratings = ratingsEntity
    }
    
    func updateSpecialPoint(withModel model: [MovieMostSpecialPointEntity]) {
        specialPointView.updateView(withModel: model)
    }
    
    func updateParticipantsView(withModel model: MovieStatisticsEntity) {
        pastFeelingsView.updateView(withModel: model.numPastValuationPercent)
        currentFeelingsView.updateView(withModel: model.numPresentValuationPercent)
        participantsCountView.updateView(withModel: model)
        genderRatioView.updateGenderRatioView(withModel: model.numGenderPercent)
        ageRatioView.updateAgeRatioView(withModel: model.numAgePercent)
    }
}
