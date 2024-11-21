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
        $0.ratioLabel.text = "0.0%"
    }
    
    private lazy var femaleContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.primary(.orange50).color
        $0.titleLabel.text = "여성"
        $0.titleLabel.textColor = ColorSet.primary(.orange90).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.primary(.orange70).color
        $0.ratioLabel.font = FontSet.label01.font
        $0.ratioLabel.text = "0.0%"
    }
    
    private lazy var unknownGenderContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.gray(.gray40).color
        $0.titleLabel.text = "비공개"
        $0.titleLabel.textColor = ColorSet.gray(.gray80).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.gray(.gray60).color
        $0.ratioLabel.font = FontSet.label01.font
        $0.ratioLabel.text = "0.0%"
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
        criteriaContainerView.addArrangedSubviews([maleContainerView, femaleContainerView, unknownGenderContainerView])
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
    
    func updateGenderRatioView(withModel model: [MovieStatisticsPercentageEntity]) {
        guard !model.isEmpty else { return }
        
        var ratioData: [Double] = []
        
        if let female = model.first(where: { $0.type == "FEMALE" }) {
            femaleContainerView.updateRatio(withRatioText: "\(female.value)%")
            
            let ratio: Double = Double(female.value) ?? 0
            ratioData.append(ratio / 100)
        } else {
            ratioData.append(0)
        }
        
        if let male = model.first(where: { $0.type == "MALE" }) {
            maleContainerView.updateRatio(withRatioText: "\(male.value)%")
            
            let ratio: Double = Double(male.value) ?? 0
            ratioData.append(ratio / 100)
        } else {
            ratioData.append(0)
        }
        
        if let unknownAge = model.first(where: { $0.type == "UNKNOWN" }) {
            unknownGenderContainerView.updateRatio(withRatioText: "\(unknownAge.value)%")
            
            let ratio: Double = Double(unknownAge.value) ?? 0
            ratioData.append(ratio / 100)
        } else {
            ratioData.append(0)
        }
        
        ratioView.drawPiChart(withData: ratioData,
                              colorList: [ColorSet.primary(.orange50).color,
                                          ColorSet.tertiary(.navy50).color,
                                          ColorSet.gray(.gray40).color])
    }
}
