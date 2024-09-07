//
//  RevaluationSpecialPointView.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import UIKit
import Then
import SnapKit

final class RevaluationSpecialPointView: UIView {
    private lazy var firstSpeicialPointView = RevaluationSpecialPointDetailView().then {
        $0.rankView.backgroundColor = ColorSet.primary(.orange40).color
        $0.rankLabel.text = "1st"
    }
    
    private lazy var secondSpeicialPointView = RevaluationSpecialPointDetailView().then {
        $0.rankView.backgroundColor = ColorSet.primary(.darkGreen40).color
        $0.rankLabel.text = "2nd"
    }
    
    private lazy var thirdSpeicialPointView = RevaluationSpecialPointDetailView().then {
        $0.rankView.backgroundColor = ColorSet.secondary(.cyan50).color
        $0.rankLabel.text = "3rd"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = moderateScale(number: 8)
        backgroundColor = ColorSet.gray(.gray20).color
        
        addSubviews([firstSpeicialPointView, secondSpeicialPointView, thirdSpeicialPointView])
        firstSpeicialPointView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        secondSpeicialPointView.snp.makeConstraints {
            $0.top.equalTo(firstSpeicialPointView.snp.bottom).offset(moderateScale(number: 9))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        thirdSpeicialPointView.snp.makeConstraints {
            $0.top.equalTo(secondSpeicialPointView.snp.bottom).offset(moderateScale(number: 9))
            $0.leading.trailing.bottom.equalToSuperview().inset(moderateScale(number: 16))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(withModel model: MovieSpecialPointEntity) {
        firstSpeicialPointView.updateView(withModel: model)
        secondSpeicialPointView.updateView(withModel: model)
        thirdSpeicialPointView.updateView(withModel: model)
    }
}
