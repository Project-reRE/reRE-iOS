//
//  AppSettingMenuItemCell.swift
//  reRE
//
//  Created by 강치훈 on 7/28/24.
//

import UIKit
import Then
import SnapKit

final class AppSettingMenuItemCell: UICollectionViewCell {
    private lazy var titleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray70).color
        $0.font = FontSet.body01.font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = ColorSet.gray(.gray20).color
        layer.masksToBounds = true
        layer.cornerRadius = moderateScale(number: 8)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 24))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(withTitle title: String) {
        titleLabel.text = title
    }
    
    func didTapCell() {
        backgroundColor = ColorSet.gray(.gray20).color?.withAlphaComponent(0.6)
        titleLabel.textColor = ColorSet.gray(.gray50).color
    }
    
    func resetCellAttibute() {
        backgroundColor = ColorSet.gray(.gray20).color
        titleLabel.textColor = ColorSet.gray(.gray70).color
    }
}
