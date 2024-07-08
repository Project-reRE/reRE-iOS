//
//  LoginUsecase.swift
//  reRE
//
//  Created by 강치훈 on 7/8/24.
//

import Foundation
import Combine

final class LoginUsecase {
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    private let mapper = BannerMapper()
    
    private let repository: LoginRepositoryProtocol
    
    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }
}

extension LoginUsecase: LoginUsecaseProtocol {
    func snsLogin(withToken accessToken: String) -> AnyPublisher<String, Never> {
        return repository.snsLogin(withToken: accessToken)
            .compactMap { [weak self] result in
                switch result {
                case .success(let jwt):
                    return jwt
                case .failure(let error):
                    self?.errorSubject.send(error)
                    return nil
                }
            }.eraseToAnyPublisher()
    }
    
    func getErrorSubject() -> AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}
