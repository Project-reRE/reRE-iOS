//
//  NoRevaluationView.swift
//  reRE
//
//  Created by chihoooon on 2024/06/06.
//

import UIKit
import SnapKit
import Then

final class NoRevaluationView: UIView {
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.body01.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "이 영화에 대한 당신의 재평가를\n처음으로 들려주세요."
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubviews([imageView, descriptionLabel])
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 152))
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(moderateScale(number: 16))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}