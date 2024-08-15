//
//  ScreenUtil.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit

let baseGuideWidth: CGFloat = 375.0
let baseGuideHeight: CGFloat = 812.0

@inline(__always)
func horizontalScale(number: CGFloat) -> CGFloat {
    UIScreen.main.bounds.width / baseGuideWidth * number
}

@inline(__always)
func verticalScale(number: CGFloat) -> CGFloat {
    let number = UIScreen.main.bounds.height / baseGuideHeight * number
    if UIScreen.main.bounds.width / UIScreen.main.bounds.height <= 0.75 {
        return number * 1.2
    }
    return UIScreen.main.bounds.height / baseGuideHeight * number
}

@inline(__always)
func moderateScale(number: CGFloat, factor: CGFloat = 0.5) -> CGFloat {
    number + (horizontalScale(number: number) - number) * factor
}

@inline(__always)
func getSafeAreaTop() -> CGFloat {
    return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0
}

@inline(__always)
func getSafeAreaBottom() -> CGFloat {
    return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.bottom ?? 0
}

@inline(__always)
func getDefaultSafeAreaBottom() -> CGFloat {
    return getSafeAreaBottom() == 0 ? moderateScale(number: 34) : getSafeAreaBottom()
}
