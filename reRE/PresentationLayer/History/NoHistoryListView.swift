//
//  NoHistoryListView.swift
//  reRE
//
//  Created by 강치훈 on 8/21/24.
//

import UIKit
import Then
import SnapKit

final class NoHistoryListView: UIStackView {
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "이번 달, 당신이 재평가할 영화는\n어떤 영화인가요?"
        $0.font = FontSet.body01.font
        $0.textColor = ColorSet.gray(.gray60).color
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private(set) lazy var doRevaluateButton = TouchableLabel().then {
        $0.text = "재평가 하러가기"
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = ColorSet.tertiary(.navy40).color
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.button01.font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .vertical
        alignment = .center
        spacing = moderateScale(number: 16)
        
        addViews()
        makeConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addArrangedSubviews([imageView, descriptionLabel, doRevaluateButton])
        setCustomSpacing(moderateScale(number: 24), after: descriptionLabel)
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 152))
        }
        
        doRevaluateButton.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 44))
            $0.width.equalTo(moderateScale(number: 176))
        }
    }
}
