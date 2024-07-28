//
//  ProfileRepository.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

final class ProfileRepository {
    private let remoteDataFetcher: RemoteDataFetchable
    
    init(remoteDataFetcher: RemoteDataFetchable) {
        self.remoteDataFetcher = remoteDataFetcher
    }
}

extension ProfileRepository: ProfileRepositoryProtocol {
    func getMyProfile() -> AnyPublisher<Result<MyProfileEntity, Error>, Never> {
        return remoteDataFetcher.getMyProfile()
    }
}