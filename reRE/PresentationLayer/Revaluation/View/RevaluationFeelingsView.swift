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
    
    func updateView(withModel model: [MovieStatisticsPercentageEntity]) {
        if let positiveModel = model.first(where: { $0.type == "POSITIVE" }) {
            if let formattedValue = Double(positiveModel.value)?.formatToString() {
                positiveFeelingsView.ratioLabel.text = "\(formattedValue)%"
            } else {
                positiveFeelingsView.ratioLabel.text = "\(positiveModel.value)%"
            }
        }
        
        if let negativeModel = model.first(where: { $0.type == "NEGATIVE" }) {
            if let formattedValue = Double(negativeModel.value)?.formatToString() {
                nagativeFeelingsView.ratioLabel.text = "\(formattedValue)%"
            } else {
                nagativeFeelingsView.ratioLabel.text = "\(negativeModel.value)%"
            }
        }
        
        if let notSureModel = model.first(where: { $0.type == "NOT_SURE" }) {
            if let formattedValue = Double(notSureModel.value)?.formatToString() {
                notSureFeelingsView.ratioLabel.text = "\(formattedValue)%"
            } else {
                notSureFeelingsView.ratioLabel.text = "\(notSureModel.value)%"
            }
        }
    }
}
