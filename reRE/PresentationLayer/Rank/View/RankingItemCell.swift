//
//  RankingItemCell.swift
//  reRE
//
//  Created by chihoooon on 2024/05/05.
//

import UIKit
import Then
import SnapKit

final class RankingItemCell: UICollectionViewCell {
    lazy var containerView = TouchableView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var thumbnailView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.cornerRadius = moderateScale(number: 4)
    }
    
    private lazy var rankLabel = UILabel().then {
        $0.text = "1"
        $0.textColor = ColorSet.gray(.white).color
        $0.textAlignment = .center
        $0.font = FontSet.body02.font
        $0.backgroundColor = .black.withAlphaComponent(0.75)
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.blue.cgColor
        $0.layer.cornerRadius = moderateScale(number: 4)
    }
    
    private lazy var movieTitleLabel = UILabel().then {
        $0.text = "영화 이름"
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title03.font
    }
    
    private lazy var titleUnderLineView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.white).color
    }
    
    private lazy var yearLabel = UILabel().then {
        $0.text = "영화 년도"
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.body04.font
    }
    
    private lazy var genreLabel = UILabel().then {
        $0.text = "장르명"
        $0.textColor = ColorSet.gray(.gray60).color
        $0.numberOfLines = 1
        $0.font = FontSet.body04.font
    }
    
    private lazy var directorLabel = UILabel().then {
        $0.text = "감독명"
        $0.textColor = ColorSet.gray(.gray60).color
        $0.numberOfLines = 1
        $0.font = FontSet.body04.font
    }
    
    private lazy var actorLabel = UILabel().then {
        $0.text = "출연배우"
        $0.textColor = ColorSet.gray(.gray60).color
        $0.numberOfLines = 1
        $0.font = FontSet.body04.font
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
        containerView.addSubviews([thumbnailView, movieTitleLabel, titleUnderLineView,
                                   yearLabel, genreLabel, directorLabel, actorLabel])
        thumbnailView.addSubview(rankLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        thumbnailView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(moderateScale(number: 110))
        }
        
        rankLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(moderateScale(number: 4))
            $0.size.equalTo(moderateScale(number: 25))
        }
        
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 7))
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(moderateScale(number: 8))
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        titleUnderLineView.snp.makeConstraints {
            $0.leading.trailing.equalTo(movieTitleLabel)
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(moderateScale(number: 5))
            $0.height.equalTo(moderateScale(number: 2))
        }
        
        yearLabel.snp.makeConstraints {
            $0.leading.equalTo(movieTitleLabel)
            $0.top.equalTo(titleUnderLineView.snp.bottom).offset(moderateScale(number: 8))
        }
        
        actorLabel.snp.makeConstraints {
            $0.leading.equalTo(movieTitleLabel)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(moderateScale(number: 8))
        }
        
        directorLabel.snp.makeConstraints {
            $0.leading.equalTo(movieTitleLabel)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(actorLabel.snp.top).offset(-moderateScale(number: 8))
        }
        
        genreLabel.snp.makeConstraints {
            $0.leading.equalTo(movieTitleLabel)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(directorLabel.snp.top).offset(-moderateScale(number: 8))
        }
    }
}
