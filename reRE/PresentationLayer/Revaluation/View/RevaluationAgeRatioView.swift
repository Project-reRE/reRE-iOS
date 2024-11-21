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
        $0.textContainerView.backgroundColor = ColorSet.primary(.orange60).color
        $0.titleLabel.text = "10대"
        $0.titleLabel.textColor = ColorSet.secondary(.cyan20).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.primary(.orange60).color
        $0.ratioLabel.font = FontSet.label01.font
        $0.ratioLabel.text = "0.0%"
    }
    
    private lazy var twentiesContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.secondary(.olive60).color
        $0.titleLabel.text = "20대"
        $0.titleLabel.textColor = ColorSet.secondary(.cyan20).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.secondary(.olive60).color
        $0.ratioLabel.font = FontSet.label01.font
        $0.ratioLabel.text = "0.0%"
    }
    
    private lazy var thirtiesContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.secondary(.cyan60).color
        $0.titleLabel.text = "30대"
        $0.titleLabel.textColor = ColorSet.secondary(.cyan20).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.secondary(.cyan60).color
        $0.ratioLabel.font = FontSet.label01.font
        $0.ratioLabel.text = "0.0%"
    }
    
    private lazy var fortiesContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.secondary(.cyan40).color
        $0.titleLabel.text = "40대"
        $0.titleLabel.textColor = ColorSet.secondary(.cyan100).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.secondary(.cyan50).color
        $0.ratioLabel.font = FontSet.label01.font
        $0.ratioLabel.text = "0.0%"
    }
    
    private lazy var fiftiesPlusContainerView = RevaluationCriteriaView().then {
        $0.textContainerView.backgroundColor = ColorSet.tertiary(.navy40).color
        $0.titleLabel.text = "50대+"
        $0.titleLabel.textColor = ColorSet.secondary(.cyan100).color
        $0.titleLabel.font = FontSet.label01.font
        $0.ratioLabel.textColor = ColorSet.tertiary(.navy70).color
        $0.ratioLabel.font = FontSet.label01.font
        $0.ratioLabel.text = "0.0%"
    }
    
    private lazy var unknownAgeContainerView = RevaluationCriteriaView().then {
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
        criteriaContainerView.addArrangedSubviews([teensContainerView, twentiesContainerView,
                                                   thirtiesContainerView, fortiesContainerView,
                                                   fiftiesPlusContainerView, unknownAgeContainerView])
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
    
    func updateAgeRatioView(withModel model: [MovieStatisticsPercentageEntity]) {
        guard !model.isEmpty else { return }
        
        var ratioData: [Double] = []
        
        if let teens = model.first(where: { $0.type == "TEENS" }) {
            teensContainerView.updateRatio(withRatioText: "\(teens.value)%")
            
            let ratio: Double = Double(teens.value) ?? 0
            ratioData.append(ratio / 100)
        } else {
            ratioData.append(0)
        }
        
        if let twenties = model.first(where: { $0.type == "TWENTIES" }) {
            twentiesContainerView.updateRatio(withRatioText: "\(twenties.value)%")
            
            let ratio: Double = Double(twenties.value) ?? 0
            ratioData.append(ratio / 100)
        } else {
            ratioData.append(0)
        }
        
        if let thirties = model.first(where: { $0.type == "THIRTIES" }) {
            thirtiesContainerView.updateRatio(withRatioText: "\(thirties.value)%")
            
            let ratio: Double = Double(thirties.value) ?? 0
            ratioData.append(ratio / 100)
        } else {
            ratioData.append(0)
        }
        
        if let forties = model.first(where: { $0.type == "FORTIES" }) {
            fortiesContainerView.updateRatio(withRatioText: "\(forties.value)%")
            
            let ratio: Double = Double(forties.value) ?? 0
            ratioData.append(ratio / 100)
        } else {
            ratioData.append(0)
        }
        
        if let fiftiesPlus = model.first(where: { $0.type == "FIFTIES_PLUS" }) {
            fiftiesPlusContainerView.updateRatio(withRatioText: "\(fiftiesPlus.value)%")
            
            let ratio: Double = Double(fiftiesPlus.value) ?? 0
            ratioData.append(ratio / 100)
        } else {
            ratioData.append(0)
        }
        
        if let unknownAge = model.first(where: { $0.type == "UNKNOWN" }) {
            unknownAgeContainerView.updateRatio(withRatioText: "\(unknownAge.value)%")
            
            let ratio: Double = Double(unknownAge.value) ?? 0
            ratioData.append(ratio / 100)
        } else {
            ratioData.append(0)
        }
        
        ratioView.drawPiChart(withData: ratioData,
                              colorList: [ColorSet.primary(.orange60).color,
                                          ColorSet.secondary(.olive60).color,
                                          ColorSet.secondary(.cyan60).color,
                                          ColorSet.secondary(.cyan40).color,
                                          ColorSet.tertiary(.navy40).color,
                                          ColorSet.gray(.gray40).color])
    }
}
