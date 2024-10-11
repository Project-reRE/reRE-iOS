//
//  ProfileRepository.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

final class ProfileRepository {
    private let localDataFetcher: LocalDataFetchable
    private let remoteDataFetcher: RemoteDataFetchable
    
    init(localDataFetcher: LocalDataFetchable, remoteDataFetcher: RemoteDataFetchable) {
        self.localDataFetcher = localDataFetcher
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
    
    func getLoginType() -> SNSLoginType? {
        guard let loginTypeString = localDataFetcher.getLoginType() else { return nil }
        guard let loginType = SNSLoginType(rawValue: loginTypeString) else { return nil }
        
        return loginType
    }
    
    func logout() {
        return remoteDataFetcher.logout()
    }
    
    func deleteAccount() -> AnyPublisher<Result<Void, Error>, Never> {
        return remoteDataFetcher.deleteAccount()
    }
}
