//
//  RevaluationCriteriaView.swift
//  reRE
//
//  Created by 강치훈 on 9/2/24.
//

import UIKit
import Then
import SnapKit

final class RevaluationCriteriaView: UIView {
    private(set) lazy var textContainerView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 4)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private(set) lazy var titleLabel = UILabel().then {
        $0.textColor = ColorSet.tertiary(.navy90).color
        $0.font = FontSet.label01.font
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private(set) lazy var ratioLabel = UILabel().then {
        $0.textColor = ColorSet.tertiary(.navy70).color
        $0.font = FontSet.label01.font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubviews([textContainerView, ratioLabel])
        textContainerView.addSubview(titleLabel)
        
        textContainerView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(moderateScale(number: 50))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 6))
            $0.centerX.equalToSuperview()
//            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 13))
        }
        
        ratioLabel.snp.makeConstraints {
            $0.centerY.equalTo(textContainerView)
            $0.leading.equalTo(textContainerView.snp.trailing).offset(moderateScale(number: 6))
            $0.trailing.equalToSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateRatio(withRatioText ratio: String) {
        ratioLabel.text = ratio
    }
}
