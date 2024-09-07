//
//  RevaluateFeelingsView.swift
//  reRE
//
//  Created by 강치훈 on 8/15/24.
//

import UIKit
import SnapKit

final class RevaluateFeelingsView: UIView {
    private(set) lazy var positiveView = RevaluationCategoryView(category: .positive)
    private(set) lazy var negativeView = RevaluationCategoryView(category: .negative)
    private(set) lazy var notSureView = RevaluationCategoryView(category: .notSure)
    
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
        addSubviews([positiveView, negativeView, notSureView])
    }
    
    private func makeConstraints() {
        let viewWidth: CGFloat = UIScreen.main.bounds.width - moderateScale(number: 32 * 2)
        let categoryWidth: CGFloat = (viewWidth - moderateScale(number: 8)) / 2
        
        positiveView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.equalTo(negativeView.snp.leading).offset(-moderateScale(number: 8))
            $0.width.equalTo(categoryWidth)
        }
        
        negativeView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
        }
        
        notSureView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(positiveView.snp.bottom).offset(moderateScale(number: 8))
            $0.width.equalTo(categoryWidth)
            $0.bottom.equalToSuperview()
        }
    }
}
