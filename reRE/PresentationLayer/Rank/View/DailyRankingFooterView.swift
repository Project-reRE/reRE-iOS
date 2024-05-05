//
//  DailyRankingFooterView.swift
//  reRE
//
//  Created by chihoooon on 2024/05/05.
//

import UIKit
import Then
import SnapKit

final class DailyRankingFooterView: UICollectionReusableView {
    private lazy var titleLabel = UILabel().then {
        $0.text = "데일리 랭킹"
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var rankingCreteriaBGView = UIView().then {
        $0.backgroundColor = ColorSet.tertiary(.navy50).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 4)
    }
    
    private lazy var rankingCreteriaLabel = UILabel().then {
        $0.text = "전일 00시 00분 ~ 23시 59분 집계 기준"
        $0.textColor = ColorSet.tertiary(.navy100).color
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "어제 재평가를 많이 받은 장르별 영화 Top 3"
        $0.textColor = ColorSet.gray(.gray70).color
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
        addSubviews([titleLabel, rankingCreteriaBGView, descriptionLabel])
        rankingCreteriaBGView.addSubview(rankingCreteriaLabel)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        rankingCreteriaBGView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(moderateScale(number: 7))
            $0.centerY.equalTo(titleLabel)
        }
        
        rankingCreteriaLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 5))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 8))
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 12))
            $0.bottom.equalToSuperview().inset(moderateScale(number: 34))
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
        }
    }
}
