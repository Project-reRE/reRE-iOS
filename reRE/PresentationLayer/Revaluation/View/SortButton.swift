//
//  SortButton.swift
//  reRE
//
//  Created by 강치훈 on 9/7/24.
//

import UIKit
import Then
import SnapKit

final class SortButton: TouchableView {
    private(set) lazy var titleLabel = UILabel().then {
        $0.font = FontSet.label01.font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.borderColor = ColorSet.gray(.gray30).color?.cgColor
        layer.borderWidth = moderateScale(number: 1)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 14))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
    
    func updateView(isSelected: Bool) {
        if isSelected {
            titleLabel.textColor = ColorSet.tertiary(.navy90).color
            backgroundColor = ColorSet.tertiary(.navy50).color
            layer.borderWidth = 0
        } else {
            titleLabel.textColor = ColorSet.gray(.gray60).color
            backgroundColor = .clear
            layer.borderWidth = moderateScale(number: 1)
        }
    }
}
