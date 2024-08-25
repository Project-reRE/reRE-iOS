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
    case signUp(params: Encodable)
    case deleteAccount
    case myProfile
    case searchMovieList(params: [String: Any])
    case myRevaluations(params: [String: Any])
    case getRevaluationDetail(params: [String: Any])
    case getMovieDetail(movieId: String)
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
            return "/auth/kakao"
        case .signUp:
            return "/users"
        case .deleteAccount:
            return "/my/users"
        case .myProfile:
            return "/my/profile"
        case .searchMovieList:
            return "/movies"
        case .myRevaluations:
            return "/my/revaluations"
        case .getRevaluationDetail:
            return "/revaluations"
        case .getMovieDetail(let movieId):
            return "/movies/\(movieId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .networkMockService: return .get
        case .rankingMovieSets: return .get
        case .rankingBanner: return .get
        case .kakaoAuth: return .get
        case .signUp: return .post
        case .deleteAccount: return .delete
        case .myProfile: return .get
        case .searchMovieList: return .get
        case .myRevaluations: return .get
        case .getRevaluationDetail: return .get
        case .getMovieDetail: return .get
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
        case .signUp(let params):
            return .requestJSONEncodable(params)
        case .deleteAccount:
            return .requestPlain
        case .myProfile:
            return .requestPlain
        case .searchMovieList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .myRevaluations(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getRevaluationDetail(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getMovieDetail:
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
