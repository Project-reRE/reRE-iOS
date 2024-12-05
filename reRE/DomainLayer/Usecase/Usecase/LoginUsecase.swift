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
    
    private let repository: LoginRepositoryProtocol
    
    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }
}

extension LoginUsecase: LoginUsecaseProtocol {
    func snsLogin(withModel model: LoginRequestModel) -> AnyPublisher<String, Never> {
        return repository.snsLogin(withModel: model)
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
    
    func signUp(withParams param: SignUpRequestModel) -> AnyPublisher<String, Never> {
        return repository.signUp(withParams: param)
            .compactMap { [weak self] result in
                switch result {
                case .success(let userId):
                    return userId
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
