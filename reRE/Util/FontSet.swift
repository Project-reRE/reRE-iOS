//
//  FontSet.swift
//  reRE
//
//  Created by chihoooon on 2024/05/05.
//

import UIKit

enum Fonts {
    case regular
    case thin
    case extraLight
    case light
    case medium
    case semiBold
    case bold
    case extraBold
    case black
    
    func font(_ size: CGFloat) -> UIFont? {
        switch self {
        case .regular:
            return UIFont(name: "Pretendard-Regular", size: size)
        case .thin:
            return UIFont(name: "Pretendard-Thin", size: size)
        case .extraLight:
            return UIFont(name: "Pretendard-ExtraLight", size: size)
        case .light:
            return UIFont(name: "Pretendard-Light", size: size)
        case .medium:
            return UIFont(name: "Pretendard-Medium", size: size)
        case .semiBold:
            return UIFont(name: "Pretendard-SemiBold", size: size)
        case .bold:
            return UIFont(name: "Pretendard-Bold", size: size)
        case .extraBold:
            return UIFont(name: "Pretendard-ExtraBold", size: size)
        case .black:
            return UIFont(name: "Pretendard-Black", size: size)
        }
    }
}

enum FontSet {
    case display01
    case display02
    
    case title01
    case title02
    case title03
    
    case button01
    case button02
    case button03
    
    case subTitle01
    
    case body01
    case body02
    case body03
    case body04
    
    case label01
    case label02
    
    var font: UIFont? {
        switch self {
        case .display01:
            return Fonts.bold.font(moderateScale(number: 32))
        case .display02:
            return Fonts.bold.font(moderateScale(number: 20))
        case .title01:
            return Fonts.semiBold.font(moderateScale(number: 18))
        case .title02:
            return Fonts.semiBold.font(moderateScale(number: 16))
        case .title03:
            return Fonts.semiBold.font(moderateScale(number: 14))
        case .button01:
            return Fonts.medium.font(moderateScale(number: 17))
        case .button02:
            return Fonts.medium.font(moderateScale(number: 15))
        case .button03:
            return Fonts.medium.font(moderateScale(number: 13))
        case .subTitle01:
            return Fonts.regular.font(moderateScale(number: 12))
        case .body01:
            return Fonts.regular.font(moderateScale(number: 16))
        case .body02:
            return Fonts.bold.font(moderateScale(number: 14))
        case .body03:
            return Fonts.regular.font(moderateScale(number: 14))
        case .body04:
            return Fonts.medium.font(moderateScale(number: 12))
        case .label01:
            return Fonts.medium.font(moderateScale(number: 14))
        case .label02:
            return Fonts.medium.font(moderateScale(number: 10))
        }
    }
}
