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
    func getMyProfile() -> AnyPublisher<Result<UserEntity, Error>, Never> {
        return remoteDataFetcher.getMyProfile()
    }
    
    func updateUserInfo(withId id: String, requestModel: UpdateUserInfoRequestModel) -> AnyPublisher<Result<UserEntity, Error>, Never> {
        return remoteDataFetcher.updateUserInfo(withId: id, requestModel: requestModel)
    }
    
    func logout() {
        return remoteDataFetcher.logout()
    }
    
    func deleteAccount() -> AnyPublisher<Result<Void, Error>, Never> {
        return remoteDataFetcher.deleteAccount()
    }
}
