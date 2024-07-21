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

enum SNSLoginType {
    case kakao
    case apple
    
    var headerName: String {
        switch self {
        case .kakao:
            return "kakao-token"
        case .apple:
            return "apple-token"
        }
    }
}
