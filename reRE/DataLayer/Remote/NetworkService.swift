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
    case rankingMovieSets
    case rankingBanner
    case kakaoAuth
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
        case .rankingMovieSets:
            return "/open-movie-sets"
        case .rankingBanner:
            return "/open-banners"
        case .kakaoAuth:
            return "/auth/kakao/404"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .networkMockService: return .get
        case .rankingMovieSets: return .get
        case .rankingBanner: return .get
        case .kakaoAuth: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .networkMockService:
            return .requestPlain
        case .rankingMovieSets:
            return .requestPlain
        case .rankingBanner:
            return .requestPlain
        case .kakaoAuth:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

// MARK: - AccessTokenAuthorizable
extension NetworkService: AccessTokenAuthorizable {
    var authorizationType: Moya.AuthorizationType? {
        return .bearer
    }
}
