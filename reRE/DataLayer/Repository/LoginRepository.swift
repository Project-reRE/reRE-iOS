//
//  LoginRepository.swift
//  reRE
//
//  Created by 강치훈 on 7/8/24.
//

import Foundation
import Combine

final class LoginRepository {
    private let remoteDataFetcher: RemoteDataFetchable
    
    init(remoteDataFetcher: RemoteDataFetchable) {
        self.remoteDataFetcher = remoteDataFetcher
    }
}

extension LoginRepository: LoginRepositoryProtocol {
    func snsLogin(withToken accessToken: String) -> AnyPublisher<Result<String, Error>, Never> {
        return remoteDataFetcher.snsLogin(withToken: accessToken)
    }
    
    func signUp(withParams param: SignUpRequestModel) -> AnyPublisher<Result<String, Error>, Never> {
        return remoteDataFetcher.signUp(withParams: param)
    }
}
