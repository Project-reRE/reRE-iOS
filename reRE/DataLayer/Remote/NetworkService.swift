//
//  NetworkService.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import Foundation
import Moya

enum NetworkService {
    case networkMockService
    case rankingBanner
}

extension NetworkService: TargetType {
    var baseURL: URL {
#if DEBUG
        return URL(string: "http://api.dev.rerevaluation.com")!
#else
        return URL(string: "api.revaluation.co.kr")!
#endif
    }
    
    var path: String {
        switch self {
        case .networkMockService:
            return "/api/v1"
        case .rankingBanner:
            return "/open-banners"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .networkMockService: return .get
        case .rankingBanner: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .networkMockService:
            return .requestPlain
        case .rankingBanner:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

// MARK: - AccessTokenAuthorizable
//extension NetworkService: AccessTokenAuthorizable {
//    var authorizationType: Moya.AuthorizationType? {
//        return .bearer
//    }
//}
