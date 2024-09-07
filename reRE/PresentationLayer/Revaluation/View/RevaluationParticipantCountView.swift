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
    private lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var countLabel = UILabel().then {
        $0.font = FontSet.body01.font
        $0.textColor = ColorSet.gray(.white).color
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubviews([iconImageView, countLabel])
        iconImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 120))
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(withModel model: MovieStatisticsEntity) {
        countLabel.text = "\(model.numStarsParticipants.formattedString())명이\n재평가에 참여했어요."
        countLabel.highLightText(targetString: model.numStarsParticipants.formattedString(),
                                 color: ColorSet.tertiary(.navy70).color,
                                 font: FontSet.title02.font)
    }
}
