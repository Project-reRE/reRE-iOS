//
//  RevaluationGenderRatioView.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import UIKit
import Then
import SnapKit

final class RevaluationGenderRatioView: UIView {
    private lazy var ratioView = RevaluationRatioView()
    
    private lazy var criteriaContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderateScale(number: 8)
    }
    
    private lazy var maleContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.tertiary(.navy50).color
        $0.titleLabel.text = "남성"
        $0.titleLabel.textColor = ColorSet.tertiary(.navy90).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.tertiary(.navy70).color
        $0.ratioLabel.font = FontSet.label01.font
    }
    
    private lazy var femaleContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.primary(.orange50).color
        $0.titleLabel.text = "여성"
        $0.titleLabel.textColor = ColorSet.primary(.orange90).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.primary(.orange70).color
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
        criteriaContainerView.addArrangedSubviews([maleContainerView, femaleContainerView])
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
    
    func updateGenderRatioView(withModel model: MovieStatisticsEntity) {
        guard model.numStarsParticipants > 0 else { return }
        
        let maleRatio: Double = Double(model.numGender.MALE) / Double(model.numStarsParticipants)
        let femaleRatio: Double = Double(model.numGender.FEMALE) / Double(model.numStarsParticipants)
        
        let moderatedMaleRatio: Double = round(maleRatio * 10000) / 100
        let moderatedFemaleRatio: Double = round(femaleRatio * 10000) / 100
        
        maleContainerView.updateRatio(withRatioText: "\(moderatedMaleRatio)%")
        femaleContainerView.updateRatio(withRatioText: "\(moderatedFemaleRatio)%")
        
        ratioView.drawPiChart(withData: [femaleRatio, maleRatio],
                              colorList: [ColorSet.primary(.orange50).color, ColorSet.tertiary(.navy50).color])
    }
}
