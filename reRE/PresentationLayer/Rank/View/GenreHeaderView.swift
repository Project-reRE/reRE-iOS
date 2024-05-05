//
//  GenreHeaderView.swift
//  reRE
//
//  Created by chihoooon on 2024/05/05.
//

import UIKit
import Then
import SnapKit

final class GenreHeaderView: UICollectionReusableView {
    private lazy var containerView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray20).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var genreView = UIView().then {
        $0.backgroundColor = ColorSet.primary(.orange40).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 12.5)
    }
    
    private lazy var genreLabel = UILabel().then {
        $0.text = "장르명"
        $0.textColor = ColorSet.primary(.orange90).color
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "가장 많은 재평가를 받은 영화 Top 3"
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
        containerView.addSubviews([genreView, descriptionLabel])
        genreView.addSubview(genreLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.trailing.equalToSuperview()
        }
        
        genreView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(moderateScale(number: 12))
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 4))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 10))
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(genreView.snp.trailing).offset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
        }
    }
    
    func updateView(property: RankingGenreProperty, genreText: String?, descriptionText: String?) {
        genreView.backgroundColor = property.backgroundColor
        genreLabel.text = genreText
        genreLabel.textColor = property.textColor
        descriptionLabel.text = descriptionText
        descriptionLabel.textColor = property.descriptionColor
    }
}
