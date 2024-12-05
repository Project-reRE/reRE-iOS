//
//  CheckMarkLabel.swift
//  reRE
//
//  Created by 강치훈 on 9/18/24.
//

import UIKit
import Then
import SnapKit

final class CheckMarkLabel: TouchableStackView {
    private(set) var isSelected: Bool = false
    
    private lazy var checkImageBGView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray40).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 10)
    }
    
    private lazy var checkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "CircleCheckIcon")
        $0.isHidden = true
    }
    
    private(set) lazy var titleLabel = UILabel().then {
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.gray80).color
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        spacing = moderateScale(number: 8)
        alignment = .center
        
        addViews()
        makeConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addArrangedSubviews([checkImageBGView, titleLabel])
        checkImageBGView.addSubview(checkImageView)
    }
    
    private func makeConstraints() {
        checkImageBGView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 20))
        }
        
        checkImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 20))
        }
    }
    
    func selectLabel(isSelected: Bool? = nil) {
        if let isSelected = isSelected {
            self.isSelected = isSelected
        } else {
            self.isSelected.toggle()
        }
        
        if self.isSelected {
            checkImageView.isHidden = false
            titleLabel.textColor = ColorSet.primary(.orange70).color
        } else {
            checkImageView.isHidden = true
            titleLabel.textColor = ColorSet.gray(.gray80).color
        }
    }
}
