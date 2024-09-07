//
//  RevaluationSpecialPointDetailView.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import UIKit
import Then
import SnapKit

final class RevaluationSpecialPointDetailView: UIStackView {
    private(set) lazy var rankView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 4)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private(set) lazy var rankLabel = UILabel().then {
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.white).color
        $0.textAlignment = .center
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var specialPointLabel = UILabel().then {
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.white).color
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var participantsNumberLabel = UILabel().then {
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.tertiary(.navy70).color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alignment = .center
        
        addArrangedSubviews([rankView, specialPointLabel, participantsNumberLabel])
        setCustomSpacing(moderateScale(number: 21), after: rankView)
        setCustomSpacing(moderateScale(number: 4), after: specialPointLabel)
        
        rankView.addSubview(rankLabel)
        
        rankView.snp.makeConstraints {
            $0.width.equalTo(moderateScale(number: 32))
            $0.height.equalTo(moderateScale(number: 22))
        }
        
        rankLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(withModel model: MovieSpecialPointEntity) {
        specialPointLabel.text = RevaluationCategoryView.CategoryType(rawValue: "ACTING_SKILLS")?.titleText
        participantsNumberLabel.text = "(\(model.ACTING_SKILLS.formattedString())명)"
    }
}
