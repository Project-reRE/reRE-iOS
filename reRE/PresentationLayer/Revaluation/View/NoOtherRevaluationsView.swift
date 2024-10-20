//
//  NoOtherRevaluationsView.swift
//  reRE
//
//  Created by 강치훈 on 10/20/24.
//

import UIKit
import Then
import SnapKit

final class NoOtherRevaluationsView: UIView {
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "NoRevaluationIcon")
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.body01.font
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "등록된 다른 평이 없어요."
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
            $0.size.equalTo(moderateScale(number: 112))
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(moderateScale(number: 8))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
