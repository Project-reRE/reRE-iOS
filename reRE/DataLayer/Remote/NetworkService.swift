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
    case getOtherRevaluations(params: [String: Any])
    case getMovieDetail(movieId: String, params: [String: String])
    case revaluate(params: Encodable)
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
        case .getOtherRevaluations:
            return "/revaluations"
        case .getMovieDetail(let movieId, _):
            return "/movies/\(movieId)"
        case .revaluate:
            return "/revaluations"
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
        case .getOtherRevaluations: return .get
        case .getMovieDetail: return .get
        case .revaluate: return .post
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
        case .getOtherRevaluations(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getMovieDetail(_, let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .revaluate(let params):
            return .requestJSONEncodable(params)
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
