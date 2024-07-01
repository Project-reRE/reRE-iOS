//
//  RankRepository.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation
import Combine

final class RankRepository {
    private let remoteDataFetcher: RemoteDataFetchable
    
    init(remoteDataFetcher: RemoteDataFetchable) {
        self.remoteDataFetcher = remoteDataFetcher
    }
}

extension RankRepository: RankRepositoryProtocol {
    func getBannerList() -> AnyPublisher<Result<[BannerEntity], Error>, Never> {
        return remoteDataFetcher.getBannerList()
    }
}
