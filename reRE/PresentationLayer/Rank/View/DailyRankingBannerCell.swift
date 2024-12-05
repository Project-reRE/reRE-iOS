//
//  DailyRankingBannerCell.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class DailyRankingBannerCell: UICollectionViewCell {
    private(set) lazy var containerView = TouchableImageView(frame: .zero).then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.kf.indicatorType = .activity
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(withModel model: BannerResponseModel) {
        containerView.kf.setImage(with: URL(string: model.imageUrl))
    }
}
