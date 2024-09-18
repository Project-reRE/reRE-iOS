//
//  RevaluationSpecialPointView.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import UIKit
import Then
import SnapKit

final class RevaluationSpecialPointView: UIView {
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderateScale(number: 9)
    }
    
    private lazy var firstSpeicialPointView = RevaluationSpecialPointDetailView().then {
        $0.rankView.backgroundColor = ColorSet.primary(.orange40).color
        $0.rankLabel.text = "1st"
    }
    
    private lazy var secondSpeicialPointView = RevaluationSpecialPointDetailView().then {
        $0.rankView.backgroundColor = ColorSet.primary(.darkGreen40).color
        $0.rankLabel.text = "2nd"
    }
    
    private lazy var thirdSpeicialPointView = RevaluationSpecialPointDetailView().then {
        $0.rankView.backgroundColor = ColorSet.secondary(.cyan50).color
        $0.rankLabel.text = "3rd"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = moderateScale(number: 8)
        backgroundColor = ColorSet.gray(.gray20).color
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        stackView.addArrangedSubviews([firstSpeicialPointView, secondSpeicialPointView, thirdSpeicialPointView])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(withModel model: [MovieMostSpecialPointEntity]) {
        if let firstSpecialPoint = model.first(where: { $0.rank == 1 }) {
            firstSpeicialPointView.isHidden = false
            firstSpeicialPointView.updateView(withModel: firstSpecialPoint)
        } else {
            firstSpeicialPointView.isHidden = true
        }
        
        if let secondSpecialPoint = model.first(where: { $0.rank == 2 }) {
            secondSpeicialPointView.isHidden = false
            secondSpeicialPointView.updateView(withModel: secondSpecialPoint)
        } else {
            secondSpeicialPointView.isHidden = true
        }
        
        if let thirdSpecialPoint = model.first(where: { $0.rank == 3 }) {
            thirdSpeicialPointView.isHidden = false
            thirdSpeicialPointView.updateView(withModel: thirdSpecialPoint)
        } else {
            thirdSpeicialPointView.isHidden = true
        }
    }
}
