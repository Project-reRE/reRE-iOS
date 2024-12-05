//
//  DailyRankingHeaderView.swift
//  reRE
//
//  Created by chihoooon on 2024/05/05.
//

import UIKit
import SnapKit
import Then

final class DailyRankingHeaderView: UICollectionReusableView {
    private lazy var titleLabel = UILabel().then {
        $0.text = "데일리 랭킹"
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.display01.font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(moderateScale(number: 16))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
