//
//  NetworkService.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import Foundation
import Moya

enum NetworkService {
    case refreshToken
    case rankingMovieSets
    case rankingBanner
    case snsLogin(loginType: SNSLoginType)
    case signUp(params: Encodable)
    case deleteAccount
    case myProfile
    case updateUserInfo(userId: String, params: Encodable)
    case searchMovieList(params: [String: Any])
    case myRevaluations(params: [String: Any])
    case getOtherRevaluations(params: [String: Any])
    case checkAlreadyRevaluated(params: [String: String])
    case getMovieDetail(movieId: String, params: [String: String])
    case revaluate(params: Encodable)
    case updateRevaluationLikes(isLiked: Bool, revaluationId: String)
    case updateRevaluation(revaluationId: String, params: Encodable)
    case deleteRevaluation(revaluationId: String)
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
        case .refreshToken:
            return "/auth/refresh"
        case .rankingMovieSets:
            return "/open-movie-sets"
        case .rankingBanner:
            return "/open-banners"
        case .snsLogin(let loginType):
            switch loginType {
            case .kakao:
                return "/auth/kakao"
            case .apple:
                return "/auth/apple"
            case .google:
                return "/auth/google"
            }
        case .signUp:
            return "/users"
        case .deleteAccount:
            return "/my/users"
        case .myProfile:
            return "/my/profile"
        case .updateUserInfo(let userId, _):
            return "/users/\(userId)"
        case .searchMovieList:
            return "/movies"
        case .myRevaluations:
            return "/my/revaluations"
        case .getOtherRevaluations:
            return "/revaluations"
        case .checkAlreadyRevaluated:
            return "/my/revaluations/check-in-month"
        case .getMovieDetail(let movieId, _):
            return "/movies/\(movieId)"
        case .revaluate:
            return "/revaluations"
        case .updateRevaluationLikes(_, let revaluationId):
            return "/revaluations/\(revaluationId)/likes"
        case .updateRevaluation(let revaluationId, _):
            return "/revaluations/\(revaluationId)"
        case .deleteRevaluation(let revaluationId):
            return "/revaluations/\(revaluationId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .refreshToken: return .get
        case .rankingMovieSets: return .get
        case .rankingBanner: return .get
        case .snsLogin: return .get
        case .signUp: return .post
        case .deleteAccount: return .delete
        case .myProfile: return .get
        case .updateUserInfo: return .put
        case .searchMovieList: return .get
        case .myRevaluations: return .get
        case .getOtherRevaluations: return .get
        case .checkAlreadyRevaluated: return .get
        case .getMovieDetail: return .get
        case .revaluate: return .post
        case .updateRevaluationLikes(let isLiked, _):
            if isLiked {
                return .post
            } else {
                return .delete
            }
        case .updateRevaluation: return .put
        case .deleteRevaluation: return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .refreshToken:
            return .requestPlain
        case .rankingMovieSets:
            return .requestPlain
        case .rankingBanner:
            return .requestPlain
        case .snsLogin:
            return .requestPlain
        case .signUp(let params):
            return .requestJSONEncodable(params)
        case .deleteAccount:
            return .requestPlain
        case .myProfile:
            return .requestPlain
        case .updateUserInfo(_, let params):
            return .requestJSONEncodable(params)
        case .searchMovieList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .myRevaluations(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getOtherRevaluations(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .checkAlreadyRevaluated(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getMovieDetail(_, let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .revaluate(let params):
            return .requestJSONEncodable(params)
        case .updateRevaluationLikes:
            return .requestPlain
        case .updateRevaluation(_, let params):
            return .requestJSONEncodable(params)
        case .deleteRevaluation:
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
