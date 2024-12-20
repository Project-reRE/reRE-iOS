//
//  RemoteDataFetcher.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import Foundation
import Combine
import Alamofire
import Moya

final class RemoteDataFetcher: RemoteDataFetchable {
    private var cancelBag = Set<AnyCancellable>()
    
    private var accessToken: String = ""
    
    private let networkManager: NetworkManager = NetworkManager.shared
    private let remoteBannerMapper = RemoteBannerMapper()
    private let remoteLoginMapper = RemoteLoginMapper()
    private let remoteProfileMapper = RemoteProfileMapper()
    private let remoteSearchMapper = RemoteSearchMapper()
    private let remoteHistoryMapper = RemoteHistoryMapper()
    private let remoteRevaluationMapper = RemoteRevaluationMapper()
    
    private enum HTTPError: LocalizedError {
        case typeMismatch
    }
    
    func versionCheck() -> AnyPublisher<Result<VersionEntity, Error>, Never> {
        return Future<Result<VersionEntity, Error>, Never> { [weak self] promise in
            let params: [String: String] = ["platform": "ios"]
            self?.networkManager.fetchPublicService(.versionCheck(params: params)) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    if let remoteItem = DecodeUtil.decode(RemoteVersionItem.self, data: response.data) {
                        promise(.success(.success(self.remoteBannerMapper.remoteVersionItemToEntity(remoteItem: remoteItem))))
                    } else {
                        LogDebug(response.data)
                        promise(.success(.failure(HTTPError.typeMismatch)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getMovieSets() -> AnyPublisher<Result<[MovieSetsEntity], Error>, Never> {
        return Future<Result<[MovieSetsEntity], Error>, Never> { [weak self] promise in
            self?.networkManager.fetchPublicService(.rankingMovieSets) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    if let remoteItem = DecodeUtil.decode([RemoteMovieSetsItem].self, data: response.data) {
                        promise(.success(.success(self.remoteBannerMapper.remoteMovieSetsItemToEntity(remoteItem: remoteItem))))
                    } else {
                        LogDebug(response.data)
                        promise(.success(.failure(HTTPError.typeMismatch)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getBannerList() -> AnyPublisher<Result<[BannerEntity], Error>, Never> {
        return Future<Result<[BannerEntity], Error>, Never> { [weak self] promise in
            self?.networkManager.fetchPublicService(.rankingBanner) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    if let remoteItem = DecodeUtil.decode(RemoteBannerItem.self, data: response.data) {
                        promise(.success(.success(self.remoteBannerMapper.remoteBannerItemToEntity(remoteItem: remoteItem))))
                    } else {
                        LogDebug(response.data)
                        promise(.success(.failure(HTTPError.typeMismatch)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func refreshToken(with jwtToken: String) {
        networkManager.fetchService(.refreshToken) { [weak self] result in
            switch result {
            case .success(let response):
                if let remoteItem = DecodeUtil.decode(RemoteLoginItem.self, data: response.data) {
                    self?.networkManager.setHeaderToken(token: remoteItem.refreshToken)
                }
            case .failure(let error):
                LogDebug(error)
            }
        }
    }
    
    func snsLogin(withModel model: LoginRequestModel) -> AnyPublisher<Result<String, Error>, Never> {
        return Future<Result<String, Error>, Never> { [weak self] promise in
            let headers: HTTPHeaders = HTTPHeaders([HTTPHeader(name: model.loginType.headerName, value: model.accessToken)])
            
            self?.networkManager.fetchService(withHeader: headers, .snsLogin(loginType: model.loginType)) { [weak self] result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        
                        self?.accessToken = model.accessToken
                        promise(.success(.failure(error)))
                    } else if let remoteItem = DecodeUtil.decode(RemoteLoginItem.self, data: response.data) {
                        if let jwtToken = remoteItem.jwt, !jwtToken.isEmpty {
                            UserDefaultsManager.shared.setLoginType(loginType: model.loginType.provider)
                            StaticValues.isLoggedIn.send(true)
                            self?.networkManager.setHeaderToken(token: jwtToken)
                            self?.refreshToken(with: jwtToken)
                        } else {
                            self?.accessToken = model.accessToken
                        }
                        
                        promise(.success(.success(remoteItem.jwt ?? "")))
                    } else {
                        LogDebug(response.data)
                        promise(.success(.failure(HTTPError.typeMismatch)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signUp(withParams param: SignUpRequestModel) -> AnyPublisher<Result<String, Error>, Never> {
        return Future<Result<String, Error>, Never> { [weak self] promise in
            guard let self = self else { return }
            
            let headers: HTTPHeaders = HTTPHeaders([HTTPHeader(name: "oAuth-token", value: self.accessToken)])
            
            self.networkManager.fetchService(withHeader: headers, .signUp(params: param)) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else if let remoteItem = DecodeUtil.decode(RemoteUserItem.self, data: response.data) {
                        UserDefaultsManager.shared.setLoginType(loginType: param.provider)
                        promise(.success(.success(remoteItem.id ?? "")))
                    } else {
                        LogDebug(response.data)
                        promise(.success(.failure(HTTPError.typeMismatch)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getMyProfile() -> AnyPublisher<Result<UserEntity, Error>, Never> {
        return Future<Result<UserEntity, Error>, Never> { [weak self] promise in
            guard let self = self else { return }
            
            self.networkManager.fetchService(.myProfile) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else if let remoteItem = DecodeUtil.decode(RemoteUserItem.self, data: response.data) {
                        promise(.success(.success(self.remoteProfileMapper.remoteMyProfileItemToEntity(remoteItem: remoteItem))))
                    } else {
                        LogDebug(response.data)
                        promise(.success(.failure(HTTPError.typeMismatch)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateUserInfo(withId id: String, requestModel: UpdateUserInfoRequestModel) -> AnyPublisher<Result<UserEntity, Error>, Never> {
        return Future<Result<UserEntity, Error>, Never> { [weak self] promise in
            guard let self = self else { return }
            
            self.networkManager.fetchService(.updateUserInfo(userId: id, params: requestModel)) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else if let remoteItem = DecodeUtil.decode(RemoteUserItem.self, data: response.data) {
                        promise(.success(.success(self.remoteProfileMapper.remoteMyProfileItemToEntity(remoteItem: remoteItem))))
                    } else {
                        LogDebug(response.data)
                        promise(.success(.failure(HTTPError.typeMismatch)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func searchMovieList(with model: SearchMovieListRequestModel) -> AnyPublisher<Result<SearchMovieListEntity, Error>, Never> {
        return Future<Result<SearchMovieListEntity, Error>, Never> { [weak self] promise in
            guard let self = self else { return }
            
            let params: [String: Any] = ["title": model.title, "limit": model.limit]
            
            self.networkManager.fetchService(.searchMovieList(params: params)) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else if let remoteItem = DecodeUtil.decode(RemoteSearchMovieListItem.self, data: response.data) {
                        promise(.success(.success(self.remoteSearchMapper.remoteSearchItemToEntity(remoteItem: remoteItem))))
                    } else {
                        LogDebug(response.data)
                        promise(.success(.failure(HTTPError.typeMismatch)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getMyHistory(with model: MyHistoryRequestModel) -> AnyPublisher<Result<MyHistoryEntity, Error>, Never> {
        return Future<Result<MyHistoryEntity, Error>, Never> { [weak self] promise in
            guard let self = self else { return }
            
            let params: [String: Any] = ["startDate": model.startDate,
                                         "endDate": model.endDate,
                                         "page": model.page,
                                         "limit": model.limit,
                                         "order": "-createdAt"]
            
            self.networkManager.fetchService(.myRevaluations(params: params)) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else if let remoteItem = DecodeUtil.decode(RemoteMyHistoryItem.self, data: response.data) {
                        promise(.success(.success(self.remoteHistoryMapper.remoteMyHistoryItemToEntity(remoteItem: remoteItem))))
                    } else {
                        LogDebug(response.data)
                        promise(.success(.failure(HTTPError.typeMismatch)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func checkAlreadyRevaluated(withId movieId: String) -> AnyPublisher<Result<MyHistoryEntityData?, Error>, Never> {
        return Future<Result<MyHistoryEntityData?, Error>, Never> { [weak self] promise in
            let params: [String: String] = ["movieId": movieId]
            
            self?.networkManager.fetchService(.checkAlreadyRevaluated(params: params)) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        promise(.success(.failure(error)))
                    } else if let remoteItem = DecodeUtil.decode(RemoteMyHistoryData.self, data: response.data) {
                        promise(.success(.success(self.remoteHistoryMapper.remoteMyHistoryDataToEntity(remoteItem: remoteItem))))
                    } else {
                        promise(.success(.success(nil)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getMovieDetail(withId movieId: String) -> AnyPublisher<Result<MovieDetailEntity, Error>, Never> {
        return Future<Result<MovieDetailEntity, Error>, Never> { [weak self] promise in
            guard let self = self else { return }
            
            var params: [String: String] = [:]
            
            if let currentDate = Date().startDayOfMonth()?.dateToString(with: "yyyy-MM") {
                params.updateValue(currentDate, forKey: "currentDate")
            }
            
            print("############")
            print("movieId: \(movieId)")
            print("params: \(params)")
            print("############")
            
            self.networkManager.fetchService(.getMovieDetail(movieId: movieId, params: params)) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else if let remoteItem = DecodeUtil.decode(RemoteMovieDetailItem.self, data: response.data) {
                        promise(.success(.success(self.remoteRevaluationMapper.remoteMovieDetailItemToEntity(remoteItem: remoteItem))))
                    } else {
                        LogDebug(response.data)
                        promise(.success(.failure(HTTPError.typeMismatch)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getOtherRevaluations(with model: OtherRevaluationsRequestModel) -> AnyPublisher<Result<OtherRevaluationsEntity, Error>, Never> {
        return Future<Result<OtherRevaluationsEntity, Error>, Never> { [weak self] promise in
            guard let self = self else { return }
            
            let order: String = model.isPopularityOrder ? "-statistics.numCommentLikes,-revaluation.createdAt" : "-createdAt"
            
            let params: [String: Any] = ["movieId": model.movieId,
                                         "order": order,
                                         "page": model.page,
                                         "limit": model.limit]
            
            self.networkManager.fetchService(.getOtherRevaluations(params: params)) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else if let remoteItem = DecodeUtil.decode(RemoteOtherRevaluationsItem.self, data: response.data) {
                        promise(.success(.success(self.remoteRevaluationMapper.remoteOtherRevaluationsItemToEntity(remoteItem: remoteItem))))
                    } else {
                        LogDebug(response.data)
                        promise(.success(.failure(HTTPError.typeMismatch)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateRevaluationLikes(withId revaluationId: String, isLiked: Bool) -> AnyPublisher<Result<String, Error>, Never> {
        return Future<Result<String, Error>, Never> { [weak self] promise in
            self?.networkManager.fetchService(.updateRevaluationLikes(isLiked: isLiked, revaluationId: revaluationId)) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else {
                        promise(.success(.success(revaluationId)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func revaluate(with reqestModel: RevaluateRequestModel) -> AnyPublisher<Result<Void, Error>, Never> {
        return Future<Result<Void, Error>, Never> { [weak self] promise in
            self?.networkManager.fetchService(.revaluate(params: reqestModel)) { result in
                switch result {
                case .success(let response):
                    LogDebug(response.data)
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else {
                        promise(.success(.success(())))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateRevaluation(withId revaluationId: String, updatedModel: RevaluateRequestModel) -> AnyPublisher<Result<MyHistoryEntityData, Error>, Never> {
        return Future<Result<MyHistoryEntityData, Error>, Never> { [weak self] promise in
            self?.networkManager.fetchService(.updateRevaluation(revaluationId: revaluationId, params: updatedModel)) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else if let remoteItem = DecodeUtil.decode(RemoteMyHistoryData.self, data: response.data) {
                        promise(.success(.success(self.remoteHistoryMapper.remoteMyHistoryDataToEntity(remoteItem: remoteItem))))
                    } else {
                        LogDebug(response.data)
                        promise(.success(.failure(HTTPError.typeMismatch)))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteRevaluation(withId revaluationId: String) -> AnyPublisher<Result<Void, Error>, Never> {
        return Future<Result<Void, Error>, Never> { [weak self] promise in
            self?.networkManager.fetchService(.deleteRevaluation(revaluationId: revaluationId)) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else {
                        promise(.success(.success(())))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func reportRevaluation(withId revaluationId: String, responseNumber: Int) -> AnyPublisher<Result<Void, Error>, Never> {
        return Future<Result<Void, Error>, Never> { [weak self] promise in
            let params: [String: Any] = ["reason": responseNumber]
            self?.networkManager.fetchService(.reportRevaluation(revaluationId: revaluationId, params: params)) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else {
                        promise(.success(.success(())))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func logout() {
        UserDefaultsManager.shared.setLoginType(loginType: nil)
        StaticValues.isLoggedIn.send(false)
        networkManager.setHeaderToken(token: nil)
    }
    
    func deleteAccount() -> AnyPublisher<Result<Void, Error>, Never> {
        return Future<Result<Void, Error>, Never> { [weak self] promise in
            guard let self = self else { return }
            
            self.networkManager.fetchService(.deleteAccount) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else {
                        self.logout()
                        promise(.success(.success(())))
                    }
                case .failure(let error):
                    promise(.success(.failure(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
}
