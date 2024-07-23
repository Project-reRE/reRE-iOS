//
//  BaseTabBar.swift
//  reRE
//
//  Created by chihoooon on 2024/06/02.
//

import UIKit

final class BaseTabBar: UITabBar {
    static var tabBarHeight: CGFloat = moderateScale(number: 56)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = moderateScale(number: 24)
        layer.masksToBounds = true
        backgroundColor = ColorSet.tertiary(.navy30).color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
        self.frame = CGRect(x: moderateScale(number: 16),
                            y: UIScreen.main.bounds.height - getSafeAreaBottom() - moderateScale(number: 56),
                            width: UIScreen.main.bounds.width - moderateScale(number: 16 * 2),
                            height: moderateScale(number: 56))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = moderateScale(number: 56)
        return sizeThatFits
    }
}
