//
//  ToggleButton.swift
//  reRE
//
//  Created by 강치훈 on 11/21/24.
//

import UIKit
import Then
import SnapKit

final class ToggleButton: TouchableStackView {
    private(set) var isSelected: Bool = false
    
    private lazy var radioButton = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray20).color
        $0.layer.masksToBounds = true
        $0.layer.borderColor = ColorSet.gray(.gray20).color?.cgColor
        $0.layer.borderWidth = moderateScale(number: 1)
        $0.layer.cornerRadius = moderateScale(number: 10)
    }
    
    private lazy var selectedCircleView = UIView().then {
        $0.backgroundColor = ColorSet.primary(.orange60).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 5)
        $0.isHidden = true
    }
    
    private(set) lazy var titleLabel = UILabel().then {
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.gray80).color
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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
        addArrangedSubviews([radioButton, titleLabel])
        radioButton.addSubview(selectedCircleView)
    }
    
    private func makeConstraints() {
        radioButton.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 20))
        }
        
        selectedCircleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 10))
        }
    }
    
    func updateRadioButton(isSelected: Bool) {
        self.isSelected = isSelected
        selectedCircleView.isHidden = !isSelected
    }
}
