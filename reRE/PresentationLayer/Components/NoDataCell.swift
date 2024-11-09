//
//  NoDataCell.swift
//  reRE
//
//  Created by 강치훈 on 10/1/24.
//

import UIKit
import Then
import SnapKit

final class NoDataCell: UICollectionViewCell {
    enum NoDataType {
        case noYesterDayRevaluations
        case noGenreRevaluations
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "NoRevaluationIcon")
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.gray60).color
        $0.textAlignment = .center
    }
    
    private(set) lazy var actionButton = TouchableLabel().then {
        $0.text = "재평가 하러가기"
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = ColorSet.tertiary(.navy40).color
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.button02.font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        
        containerView.addSubviews([imageView, descriptionLabel, actionButton])
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 112))
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(moderateScale(number: 8))
            $0.centerX.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 44))
            $0.width.equalTo(moderateScale(number: 176))
            $0.bottom.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(with type: NoDataType, genre: String? = nil) {
        switch type {
        case .noYesterDayRevaluations:
            descriptionLabel.text = "어제 재평가된 영화가 없어요!\n여러분의 재평가를 공유해 주세요."
        case .noGenreRevaluations:
            guard let genre = genre else { return }
            
            descriptionLabel.text = "'\(genre)'에 대한 평가가 없어요!\n처음으로 재평가를 해주시는 건 어떨까요?"
        }
    }
}
