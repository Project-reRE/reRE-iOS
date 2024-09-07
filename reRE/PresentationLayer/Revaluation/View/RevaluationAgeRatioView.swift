//
//  RevaluationAgeRatioView.swift
//  reRE
//
//  Created by 강치훈 on 9/2/24.
//

import UIKit
import Then
import SnapKit

final class RevaluationAgeRatioView: UIView {
    private lazy var ratioView = RevaluationRatioView()
    
    private lazy var criteriaContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderateScale(number: 8)
    }
    
    private lazy var teensContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.secondary(.cyan80).color
        $0.titleLabel.text = "10대"
        $0.titleLabel.textColor = ColorSet.secondary(.cyan20).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.secondary(.cyan60).color
        $0.ratioLabel.font = FontSet.label01.font
    }
    
    private lazy var twentiesContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.secondary(.cyan70).color
        $0.titleLabel.text = "20대"
        $0.titleLabel.textColor = ColorSet.secondary(.cyan20).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.secondary(.cyan60).color
        $0.ratioLabel.font = FontSet.label01.font
    }
    
    private lazy var thirtiesContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.secondary(.cyan60).color
        $0.titleLabel.text = "30대"
        $0.titleLabel.textColor = ColorSet.secondary(.cyan20).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.secondary(.cyan60).color
        $0.ratioLabel.font = FontSet.label01.font
    }
    
    private lazy var fortiesContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.secondary(.cyan40).color
        $0.titleLabel.text = "40대"
        $0.titleLabel.textColor = ColorSet.secondary(.cyan100).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.secondary(.cyan60).color
        $0.ratioLabel.font = FontSet.label01.font
    }
    
    private lazy var fiftiesPlusContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.secondary(.cyan30).color
        $0.titleLabel.text = "50대+"
        $0.titleLabel.textColor = ColorSet.secondary(.cyan100).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.secondary(.cyan60).color
        $0.ratioLabel.font = FontSet.label01.font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubviews([ratioView, criteriaContainerView])
        criteriaContainerView.addArrangedSubviews([teensContainerView, twentiesContainerView,
                                                   thirtiesContainerView, fortiesContainerView,
                                                   fiftiesPlusContainerView])
    }
    
    private func makeConstraints() {
        ratioView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 190))
        }
        
        criteriaContainerView.snp.makeConstraints {
            $0.centerY.equalTo(ratioView)
            $0.leading.equalTo(ratioView.snp.trailing).offset(moderateScale(number: 16))
            $0.trailing.equalToSuperview()
        }
    }
    
    func updateAgeRatioView(withModel model: MovieStatisticsEntity) {
        guard model.numStarsParticipants > 0 else { return }
        
        let teensRatio: Double = Double(model.numAge.TEENS) / Double(model.numStarsParticipants)
        let moderatedTeensRatio: Double = round(teensRatio * 10000) / 100
        teensContainerView.updateRatio(withRatioText: "\(moderatedTeensRatio)%")
        
        let twentiesRatio: Double = Double(model.numAge.TWENTIES) / Double(model.numStarsParticipants)
        let moderatedTwentiesRatio: Double = round(twentiesRatio * 10000) / 100
        twentiesContainerView.updateRatio(withRatioText: "\(moderatedTwentiesRatio)%")
        
        let thirtiesRatio: Double = Double(model.numAge.THIRTIES) / Double(model.numStarsParticipants)
        let moderatedThirtiesRatio: Double = round(thirtiesRatio * 10000) / 100
        thirtiesContainerView.updateRatio(withRatioText: "\(moderatedThirtiesRatio)%")
        
        let fortiesRatio: Double = Double(model.numAge.FORTIES) / Double(model.numStarsParticipants)
        let moderatedFourtiesRatio: Double = round(fortiesRatio * 10000) / 100
        fortiesContainerView.updateRatio(withRatioText: "\(moderatedFourtiesRatio)%")
        
        let fiftiesPlusRatio: Double = Double(model.numAge.FIFTIES_PLUS) / Double(model.numStarsParticipants)
        let moderatedFiftiesPlusRatio: Double = round(fiftiesPlusRatio * 10000) / 100
        fiftiesPlusContainerView.updateRatio(withRatioText: "\(moderatedFiftiesPlusRatio)%")
        
        ratioView.drawPiChart(withData: [teensRatio, twentiesRatio, thirtiesRatio, fortiesRatio, fiftiesPlusRatio],
                              colorList: [ColorSet.secondary(.cyan80).color,
                                          ColorSet.secondary(.cyan70).color,
                                          ColorSet.secondary(.cyan60).color,
                                          ColorSet.secondary(.cyan50).color,
                                          ColorSet.secondary(.cyan40).color])
    }
}
