//
//  Enums.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import Foundation

enum TabType: Int {
    case rank
    case search
    case history
    case myPage
}

enum SNSLoginType: String {
    case kakao
    case apple
    case google
    
    var headerName: String {
        switch self {
        case .kakao:
            return "kakao-token"
        case .apple:
            return "apple-token"
        case .google:
            return "google-token"
        }
    }
    
    var provider: String {
        switch self {
        case .kakao:
            return "kakao"
        case .apple:
            return "apple"
        case .google:
            return "google"
        }
    }
}

enum AppSettingMenu: Int, CaseIterable {
    case servicePolicy
    case privacyPolicy
    case termsPolicy
    case openSourceLicense
    case openAPI
    
    var titleText: String {
        switch self {
        case .servicePolicy:
            return "서비스 이용약관 보기"
        case .privacyPolicy:
            return "개인정보 처리방침 보기"
        case .termsPolicy:
            return "운영 정책 보기"
        case .openSourceLicense:
            return "사용한 오픈소스 라이선스 보기"
        case .openAPI:
            return "사용한 오픈 API 보기"
        }
    }
}
