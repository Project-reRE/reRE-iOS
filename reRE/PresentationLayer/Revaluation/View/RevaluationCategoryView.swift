//
//  RevaluationCategoryView.swift
//  reRE
//
//  Created by 강치훈 on 8/15/24.
//

import UIKit
import Then
import SnapKit

final class RevaluationCategoryView: TouchableView {
    enum CategoryType: String {
        case planningIntent = "PLANNING_INTENT"
        case directorsDirection = "DIRECTORS_DIRECTION"
        case actingSkills = "ACTING_SKILLS"
        case scenario = "SCENARIO"
        case ost = "OST"
        case socialIssues = "SOCIAL_ISSUES"
        case visualElement = "VISUAL_ELEMENT"
        case soundElement = "SOUND_ELEMENT"
        case positive = "POSITIVE"
        case negative = "NEGATIVE"
        case notSure = "NOT_SURE"
        
        var titleText: String {
            switch self {
            case .planningIntent:
                return "기획 의도"
            case .directorsDirection:
                return "감독의 연출"
            case .actingSkills:
                return "출연진 연기력"
            case .scenario:
                return "시나리오"
            case .visualElement:
                return "시각적 요소"
            case .soundElement:
                return "음향적 요소"
            case .ost:
                return "OST"
            case .socialIssues:
                return "사회적 이슈"
            case .positive:
                return "긍정적"
            case .negative:
                return "부정적"
            case .notSure:
                return "잘 모름"
            }
        }
    }
    
    private lazy var categoryTitleLabel = UILabel().then {
        $0.text = category.titleText
        $0.font = FontSet.body01.font
        $0.textColor = ColorSet.gray(.gray60).color
        $0.numberOfLines = 0
    }
    
    private let category: CategoryType
    
    init(category: CategoryType) {
        self.category = category
        super.init(frame: .zero)
        
        backgroundColor = .clear
        layer.masksToBounds = true
        layer.borderColor = ColorSet.gray(.gray30).color?.cgColor
        layer.borderWidth = moderateScale(number: 1)
        
        addSubview(categoryTitleLabel)
        categoryTitleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 14))
            $0.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
    
    func updateView(isSelected: Bool) {
        if isSelected {
            categoryTitleLabel.textColor = ColorSet.primary(.darkGreen90).color
            backgroundColor = ColorSet.primary(.darkGreen40).color
            layer.borderWidth = 0
        } else {
            categoryTitleLabel.textColor = ColorSet.gray(.gray60).color
            backgroundColor = .clear
            layer.borderWidth = 1
        }
    }
    
    func getCategoryType() -> CategoryType {
        return category
    }
}
