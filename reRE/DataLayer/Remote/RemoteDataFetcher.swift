//
//  RemoteDataFetcher.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import Foundation
import Combine

final class RemoteDataFetcher: RemoteDataFetchable {
    private var cancelBag = Set<AnyCancellable>()
    
    private let networkManager: NetworkManager = NetworkManager.shared
    private let remoteBannerMapper = RemoteBannerMapper()
    
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
}