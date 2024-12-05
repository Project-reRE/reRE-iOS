//
//  RevaluationParticipantCountView.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import UIKit
import Then
import SnapKit

final class RevaluationParticipantCountView: UIView {
    private lazy var titleLabel = UILabel().then {
        $0.text = "평가자 수"
        $0.font = FontSet.body01.font
        $0.textColor = ColorSet.gray(.gray60).color
    }
    
    private lazy var countLabel = UILabel().then {
        $0.font = FontSet.display02.font
        $0.textColor = ColorSet.gray(.white).color
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = ColorSet.gray(.gray20).color
        layer.masksToBounds = true
        layer.cornerRadius = moderateScale(number: 8)
        
        addSubviews([titleLabel, countLabel])
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 24))
            $0.centerX.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 10))
            $0.bottom.equalToSuperview().inset(moderateScale(number: 24))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(withModel model: MovieStatisticsEntity) {
        countLabel.text = "\(model.numStarsParticipants.formattedString())명"
    }
}
