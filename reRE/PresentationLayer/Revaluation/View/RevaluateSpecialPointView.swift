//
//  RevaluateSpecialPointView.swift
//  reRE
//
//  Created by 강치훈 on 8/15/24.
//

import UIKit
import SnapKit

final class RevaluateSpecialPointView: UIView {
    private(set) lazy var planningIntentView = RevaluationCategoryView(category: .planningIntent)
    private(set) lazy var directorsDirectionView = RevaluationCategoryView(category: .directorsDirection)
    private(set) lazy var actingSkillsView = RevaluationCategoryView(category: .actingSkills)
    private(set) lazy var scenarioView = RevaluationCategoryView(category: .scenario)
    private(set) lazy var visualElementView = RevaluationCategoryView(category: .visualElement)
    private(set) lazy var soundElementView = RevaluationCategoryView(category: .soundElement)
    private(set) lazy var ostView = RevaluationCategoryView(category: .ost)
    private(set) lazy var socialIssuesView = RevaluationCategoryView(category: .socialIssues)
    
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
        addSubviews([planningIntentView, directorsDirectionView, actingSkillsView, scenarioView,
                     visualElementView, soundElementView, ostView, socialIssuesView])
    }
    
    private func makeConstraints() {
        let viewWidth: CGFloat = UIScreen.main.bounds.width - moderateScale(number: 32 * 2)
        let categoryWidth: CGFloat = (viewWidth - moderateScale(number: 8)) / 2
        
        planningIntentView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.equalTo(directorsDirectionView.snp.leading).offset(-moderateScale(number: 8))
            $0.width.equalTo(categoryWidth)
        }
        
        directorsDirectionView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
        }
        
        actingSkillsView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(planningIntentView.snp.bottom).offset(moderateScale(number: 8))
            $0.trailing.equalTo(scenarioView.snp.leading).offset(-moderateScale(number: 8))
            $0.width.equalTo(categoryWidth)
        }
        
        scenarioView.snp.makeConstraints {
            $0.top.equalTo(actingSkillsView)
            $0.trailing.equalToSuperview()
        }
        
        visualElementView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(actingSkillsView.snp.bottom).offset(moderateScale(number: 8))
            $0.trailing.equalTo(soundElementView.snp.leading).offset(-moderateScale(number: 8))
            $0.width.equalTo(categoryWidth)
        }
        
        soundElementView.snp.makeConstraints {
            $0.top.equalTo(visualElementView)
            $0.trailing.equalToSuperview()
        }
        
        ostView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(visualElementView.snp.bottom).offset(moderateScale(number: 8))
            $0.trailing.equalTo(socialIssuesView.snp.leading).offset(-moderateScale(number: 8))
            $0.width.equalTo(categoryWidth)
            $0.bottom.equalToSuperview()
        }
        
        socialIssuesView.snp.makeConstraints {
            $0.top.equalTo(ostView)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
