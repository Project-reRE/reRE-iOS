//
//  RevaluationFeelingsDetailView.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import UIKit
import Then
import SnapKit

final class RevaluationFeelingsDetailView: UIView {
    private lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        
        switch feelings {
        case .positive:
            $0.image = UIImage(named: "PositiveIcon")
        case .negative:
            $0.image = UIImage(named: "NegativeIcon")
        case .notSure:
            $0.image = UIImage(named: "NotSureIcon")
        default:
            break
        }
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = feelings.titleText
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.body03.font
        $0.textAlignment = .center
    }
    
    private(set) lazy var ratioLabel = UILabel().then {
        $0.text = "0.00%"
        $0.font = FontSet.label01.font
        $0.textAlignment = .center
        
        switch feelings {
        case .positive:
            $0.textColor = ColorSet.secondary(.olive50).color
        case .negative:
            $0.textColor = ColorSet.primary(.orange40).color
        case .notSure:
            $0.textColor = ColorSet.gray(.gray60).color
        default:
            break
        }
    }
    
    private let feelings: RevaluationCategoryView.CategoryType
    
    init(feelings: RevaluationCategoryView.CategoryType) {
        self.feelings = feelings
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        addSubviews([iconImageView, titleLabel, ratioLabel])
        
        iconImageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 80))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(moderateScale(number: 8))
            $0.centerX.equalTo(iconImageView)
        }
        
        ratioLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 3))
            $0.centerX.equalTo(iconImageView)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
