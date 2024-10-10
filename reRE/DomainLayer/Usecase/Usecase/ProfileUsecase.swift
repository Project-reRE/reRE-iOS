//
//  ProfileUsecase.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

final class ProfileUsecase {
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
}

extension ProfileUsecase: ProfileUsecaseProtocol {
    func getMyProfile() -> AnyPublisher<UserEntity, Never> {
        return repository.getMyProfile()
            .compactMap { [weak self] result in
                switch result {
                case .success(let entity):
                    return entity
                case .failure(let error):
                    self?.errorSubject.send(error)
                    return nil
                }
            }.eraseToAnyPublisher()
    }
    
    func updateUserInfo(withId id: String, requestModel: UpdateUserInfoRequestModel) -> AnyPublisher<UserEntity, Never> {
        return repository.updateUserInfo(withId: id, requestModel: requestModel)
            .compactMap { [weak self] result in
                switch result {
                case .success(let entity):
                    return entity
                case .failure(let error):
                    self?.errorSubject.send(error)
                    return nil
                }
            }.eraseToAnyPublisher()
    }
    
    func logout() {
        repository.logout()
    }
    
    func deleteAccount() -> AnyPublisher<Void, Never> {
        return repository.deleteAccount()
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
