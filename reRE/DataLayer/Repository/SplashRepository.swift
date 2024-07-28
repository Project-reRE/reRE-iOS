//
//  SplashRepository.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

final class SplashRepository {
    private let localDataFetcher: LocalDataFetchable
    private let remoteDataFetcher: RemoteDataFetchable
    
    init(localDataFetcher: LocalDataFetchable, remoteDataFetcher: RemoteDataFetchable) {
        self.localDataFetcher = localDataFetcher
        self.remoteDataFetcher = remoteDataFetcher
    }
}

extension SplashRepository: SplashRepositoryProtocol {
    func getLoginType() -> SNSLoginType? {
        guard let loginTypeString = localDataFetcher.getLoginType() else {
            print("1")
            return nil
        }
        guard let loginType = SNSLoginType(rawValue: loginTypeString) else {
            print("2")
            return nil
        }
        
        return loginType
    }
    
    func snsLogin(withModel model: LoginRequestModel) -> AnyPublisher<Result<String, Error>, Never> {
        return remoteDataFetcher.snsLogin(withModel: model)
    }
}