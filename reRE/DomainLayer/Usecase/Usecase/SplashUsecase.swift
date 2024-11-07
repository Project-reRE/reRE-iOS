//
//  SplashUsecase.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

final class SplashUsecase {
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    private let repository: SplashRepositoryProtocol
    
    init(repository: SplashRepositoryProtocol) {
        self.repository = repository
    }
}

extension SplashUsecase: SplashUsecaseProtocol {
    func versionCheck() -> AnyPublisher<VersionEntity, Never> {
        return repository.versionCheck()
            .compactMap { [weak self] result in
                switch result {
                case .success(let versionEntity):
                    return versionEntity
                case .failure(let error):
                    self?.errorSubject.send(error)
                    return nil
                }
            }.eraseToAnyPublisher()
    }
    
    func getLoginType() -> SNSLoginType? {
        return repository.getLoginType()
    }
    
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
    
    func getErrorSubject() -> AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}
