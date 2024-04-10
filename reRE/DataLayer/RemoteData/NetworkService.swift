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
}

extension NetworkService: TargetType {
    var baseURL: URL {
        return URL(string: "www.naver.com")!
    }
    
    var path: String {
        switch self {
        case .networkMockService:
            return "/api/v1"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .networkMockService: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .networkMockService:
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
