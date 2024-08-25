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
    
    private lazy var maleContainerView = UIView()
    
    private lazy var maleTextView = UIView().then {
        $0.backgroundColor = ColorSet.tertiary(.navy50).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 4)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var maleTextLabel = UILabel().then {
        $0.text = "남성"
        $0.textColor = ColorSet.tertiary(.navy90).color
        $0.font = FontSet.label01.font
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var maleRatioLabel = UILabel().then {
        $0.textColor = ColorSet.tertiary(.navy70).color
        $0.font = FontSet.label01.font
    }
    
    private lazy var femaleContainerView = UIView()
    
    private lazy var femaleTextView = UIView().then {
        $0.backgroundColor = ColorSet.primary(.orange50).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 4)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var femaleTextLabel = UILabel().then {
        $0.text = "여성"
        $0.textColor = ColorSet.primary(.orange90).color
        $0.font = FontSet.label01.font
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var femaleRatioLabel = UILabel().then {
        $0.textColor = ColorSet.primary(.orange70).color
        $0.font = FontSet.label01.font
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
        
        maleContainerView.addSubviews([maleTextView, maleRatioLabel])
        maleTextView.addSubview(maleTextLabel)
        
        femaleContainerView.addSubviews([femaleTextView, femaleRatioLabel])
        femaleTextView.addSubview(femaleTextLabel)
    }
    
    private func makeConstraints() {
        ratioView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 190))
        }
        
        criteriaContainerView.snp.makeConstraints {
            $0.centerY.equalTo(ratioView)
            $0.leading.equalTo(ratioView.snp.trailing).offset(moderateScale(number: 16))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 24))
        }
        
        maleTextView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        maleTextLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 6))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 13))
        }
        
        maleRatioLabel.snp.makeConstraints {
            $0.centerY.equalTo(maleTextView)
            $0.leading.equalTo(maleTextView.snp.trailing).offset(moderateScale(number: 6))
            $0.trailing.equalToSuperview()
        }
        
        femaleTextView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        femaleTextLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 6))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 13))
        }
        
        femaleRatioLabel.snp.makeConstraints {
            $0.centerY.equalTo(femaleTextView)
            $0.leading.equalTo(femaleTextView.snp.trailing).offset(moderateScale(number: 6))
            $0.trailing.equalToSuperview()
        }
    }
    
    func updateGenderRatioView(withModel model: MovieStatisticsEntity) {
        maleRatioLabel.text = "\(model.numGender.MALE)"
        femaleRatioLabel.text = "\(model.numGender.FEMALE)"
        
        let maleRatio: Double = Double(model.numGender.MALE) / Double(model.numStarsParticipants)
        let femaleRatio: Double = Double(model.numGender.FEMALE) / Double(model.numStarsParticipants)
        
        ratioView.drawPiChart(withData: [femaleRatio, maleRatio],
                              colorList: [ColorSet.primary(.orange50).color, ColorSet.tertiary(.navy50).color])
    }
}
