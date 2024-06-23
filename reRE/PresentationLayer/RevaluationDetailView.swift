//
//  RevaluationDetailView.swift
//  reRE
//
//  Created by chihoooon on 2024/06/23.
//

import UIKit
import Then
import SnapKit

final class RevaluationDetailView: UIStackView {
    private lazy var gradeContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var gradeTitleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title01.font
    }
    
    private lazy var gradeLabel = UILabel().then {
        $0.textColor = ColorSet.primary(.orange60).color
        $0.font = FontSet.display01.font
    }
    
    private lazy var gradeImageStackView = UIStackView().then {
        $0.spacing = moderateScale(number: 8)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        spacing = moderateScale(number: 48)
        
        addViews()
        makeConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addArrangedSubviews([gradeContainerView])
        gradeContainerView.addSubviews([gradeTitleLabel, gradeLabel, gradeImageStackView])
        
        for _ in 0..<5 {
            let gradeImageView: UIImageView = UIImageView()
            gradeImageView.contentMode = .scaleAspectFit
            gradeImageView.image = UIImage(named: "GradeStar")?.withTintColor(ColorSet.gray(.gray40).color!,
                                                                              renderingMode: .alwaysTemplate)
            
            gradeImageStackView.addArrangedSubview(gradeImageView)
        }
    }
    
    private func makeConstraints() {
        gradeTitleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        gradeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(gradeTitleLabel.snp.bottom).offset(moderateScale(number: 24))
        }
        
        gradeImageStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(gradeLabel.snp.bottom).offset(moderateScale(number: 8))
        }
        
        gradeImageStackView.arrangedSubviews.forEach { subView in
            subView.snp.makeConstraints {
                $0.size.equalTo(moderateScale(number: 28))
            }
        }
    }
    
    func updateGradeView(ofDate DateString: String, grade: CGFloat) {
        gradeTitleLabel.text = DateString
        
        let decimalNumber = Int(grade * 100) / 100
        let floatingNumber: CGFloat = CGFloat(Int(grade * 100) % 100) / 100
        gradeLabel.text = "\(CGFloat(decimalNumber) + floatingNumber)"
        
        for (index, subView) in gradeImageStackView.arrangedSubviews.enumerated() {
            if index < decimalNumber {
                (subView as? UIImageView)?.tintColor = ColorSet.primary(.orange60).color
            } else if index == decimalNumber {
                (subView as? UIImageView)?.fillColor(with: ColorSet.primary(.orange60).color,
                                                     percentage: floatingNumber)
            } else {
                (subView as? UIImageView)?.tintColor = ColorSet.gray(.gray40).color
            }
        }
    }
}
