//
//  SearchResultItemCell.swift
//  reRE
//
//  Created by chihoooon on 2024/06/02.
//

import UIKit
import SnapKit
import Then

final class SearchResultItemCell: UICollectionViewCell {
    lazy var containerView = TouchableView()
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.red.cgColor
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title03.font
        $0.text = "영화 제목영화 제목영화 제목영화 제목영화 제목영화 제목영화 제목"
    }
    
    private lazy var yearLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.body04.font
        $0.text = "2015"
    }
    
    private lazy var genresLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.body04.font
        $0.text = "장르명 장르명 장르명 장르명 장르명 장르명 장르명 "
    }
    
    private lazy var directorsLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.body04.font
        $0.text = "감독명 감독명 감독명 감독명 감독명 감독명 감독명 "
    }
    
    private lazy var actorsLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.body04.font
        $0.text = "배우명 배우명 배우명 배우명 배우명 배우명 배우명 "
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
        addSubview(containerView)
        containerView.addSubviews([thumbnailImageView, titleLabel, yearLabel,
                                   genresLabel, directorsLabel, actorsLabel])
    }
    
    private func makeConstraints() {
        containerView.layer.borderColor = UIColor.blue.cgColor
        containerView.layer.borderWidth = 1
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(moderateScale(number: 74))
            $0.height.equalTo(moderateScale(number: 111))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 4))
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(moderateScale(number: 14))
            $0.trailing.equalToSuperview()
        }
        
        yearLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 4))
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        genresLabel.snp.makeConstraints {
            $0.top.equalTo(yearLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        directorsLabel.snp.makeConstraints {
            $0.top.equalTo(genresLabel.snp.bottom).offset(moderateScale(number: 4))
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        actorsLabel.snp.makeConstraints {
            $0.top.equalTo(directorsLabel.snp.bottom).offset(moderateScale(number: 4))
            $0.leading.trailing.equalTo(titleLabel)
        }
    }
}
