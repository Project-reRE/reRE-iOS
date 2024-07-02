//
//  DailyRankingBannerCell.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit
import Then
import SnapKit

final class DailyRankingBannerCell: UICollectionViewCell {
    private lazy var containerView = TouchableView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 16)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = ColorSet.gray(.black).color
        $0.font = FontSet.display02.font
    }
    
    private lazy var moreLabel = UILabel().then {
        $0.text = "더보기"
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.body02.font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([titleLabel, moreLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 32))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 24))
        }
        
        moreLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 24))
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 16))
        }
    }
    
    func updateView(withModel model: BannerResponseModel) {
        titleLabel.text = model.title
        containerView.backgroundColor = UIColor(hexString: model.boxHexCode)
    }
}
