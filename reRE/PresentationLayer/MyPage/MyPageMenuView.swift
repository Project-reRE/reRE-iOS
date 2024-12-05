//
//  MyPageMenuView.swift
//  reRE
//
//  Created by 강치훈 on 7/23/24.
//

import UIKit
import Then
import SnapKit

final class MyPageMenuView: UIView {
    lazy var containerView = TouchableView().then {
        $0.backgroundColor = .clear
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray70).color
        $0.font = FontSet.body01.font
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
        containerView.addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 8))
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 16))
        }
    }
}
