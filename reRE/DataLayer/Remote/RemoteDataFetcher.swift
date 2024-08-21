//
//  RemoteDataFetcher.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import Foundation
import Combine
import Alamofire

final class RemoteDataFetcher: RemoteDataFetchable {
    private var cancelBag = Set<AnyCancellable>()
    
    private var accessToken: String = ""
    
    private let networkManager: NetworkManager = NetworkManager.shared
    private let remoteBannerMapper = RemoteBannerMapper()
    private let remoteLoginMapper = RemoteLoginMapper()
    private let remoteProfileMapper = RemoteProfileMapper()
    private let remoteSearchMapper = RemoteSearchMapper()
    private let remoteHistoryMapper = RemoteHistoryMapper()
    
    private enum HTTPError: LocalizedError {
        case typeMismatch
    }
    
    func getMovieSets() -> AnyPublisher<Result<[MovieSetsEntity], Error>, Never> {
        return Future<Result<[MovieSetsEntity], Error>, Never> { [weak self] promise in
            self?.networkManager.fetchPublicService(.rankingMovieSets) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    if let remoteItem = DecodeUtil.decode(RemoteMovieSetsItem.self, data: response.data) {
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
    
    func snsLogin(withModel model: LoginRequestModel) -> AnyPublisher<Result<String, Error>, Never> {
        return Future<Result<String, Error>, Never> { [weak self] promise in
            let headers: HTTPHeaders = HTTPHeaders([HTTPHeader(name: model.loginType.headerName, value: model.accessToken)])
            self?.networkManager.fetchService(withHeader: headers, .kakaoAuth) { [weak self] result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        
                        self?.accessToken = model.accessToken
                        promise(.success(.failure(error)))
                    } else if let remoteItem = DecodeUtil.decode(RemoteLoginItem.self, data: response.data) {
                        LogDebug(response.data)
                        if let jwtToken = remoteItem.jwt, !jwtToken.isEmpty {
                            UserDefaultsManager.shared.setLoginType(loginType: model.loginType.rawValue)
                            StaticValues.isLoggedIn.send(true)
                            self?.networkManager.setHeaderToken(token: jwtToken)
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
                    } else if let userId = DecodeUtil.decode(String.self, data: response.data) {
                        UserDefaultsManager.shared.setLoginType(loginType: param.provider)
                        promise(.success(.success(userId)))
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
    
    func getMyProfile() -> AnyPublisher<Result<MyProfileEntity, Error>, Never> {
        return Future<Result<MyProfileEntity, Error>, Never> { [weak self] promise in
            guard let self = self else { return }
            
            self.networkManager.fetchService(.myProfile) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else if let remoteItem = DecodeUtil.decode(RemoteMyProfileItem.self, data: response.data) {
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
                                         "limit": model.limit]
            
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
    
    func logout() {
        UserDefaultsManager.shared.setLoginType(loginType: nil)
        StaticValues.isLoggedIn.send(false)
        networkManager.setHeaderToken(token: nil)
    }
    
    func deleteAccount() -> AnyPublisher<Result<String, Error>, Never> {
        return Future<Result<String, Error>, Never> { [weak self] promise in
            guard let self = self else { return }
            
            self.networkManager.fetchService(.deleteAccount) { result in
                switch result {
                case .success(let response):
                    if let error = DecodeUtil.decode(UserError.self, data: response.data) {
                        LogDebug(error)
                        promise(.success(.failure(error)))
                    } else if let userId = DecodeUtil.decode(String.self, data: response.data) {
                        self.logout()
                        promise(.success(.success(userId)))
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
}
