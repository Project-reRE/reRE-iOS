//
//  BaseTabBar.swift
//  reRE
//
//  Created by chihoooon on 2024/06/02.
//

import UIKit
import Then
import SnapKit

final class BaseTabBar: UITabBar {
    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = ColorSet.tertiary(.navy30).color
        $0.layer.cornerRadius = moderateScale(number: 24)
        $0.layer.masksToBounds = true
    }
    
    static var tabBarHeight: CGFloat = moderateScale(number: 56)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.bottom.equalToSuperview().inset(getDefaultSafeAreaBottom())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = moderateScale(number: 56) + getDefaultSafeAreaBottom()
        return sizeThatFits
    }
}
