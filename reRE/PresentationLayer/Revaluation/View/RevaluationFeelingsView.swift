//
//  RevaluationFeelingsView.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import UIKit
import Then
import SnapKit

final class RevaluationFeelingsView: UIStackView {
    private lazy var positiveFeelingsView = RevaluationFeelingsDetailView(feelings: .positive)
    private lazy var nagativeFeelingsView = RevaluationFeelingsDetailView(feelings: .negative)
    private lazy var notSureFeelingsView = RevaluationFeelingsDetailView(feelings: .notSure)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        spacing = moderateScale(number: 16)
        distribution = .fillEqually
        
        addArrangedSubviews([positiveFeelingsView, nagativeFeelingsView, notSureFeelingsView])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(withModel model: MovieFeelingsEntity) {
        positiveFeelingsView.updateView(withModel: model)
        nagativeFeelingsView.updateView(withModel: model)
        notSureFeelingsView.updateView(withModel: model)
    }
}
