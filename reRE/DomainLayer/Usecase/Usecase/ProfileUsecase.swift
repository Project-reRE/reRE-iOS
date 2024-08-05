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
    
    private let mapper = ProfileMapper()
    
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
}

extension ProfileUsecase: ProfileUsecaseProtocol {
    func getMyProfile() -> AnyPublisher<MyProfileResponseModel, Never> {
        return repository.getMyProfile()
            .compactMap { [weak self] result in
                switch result {
                case .success(let entity):
                    return self?.mapper.myProfileEntityToModel(entity: entity)
                case .failure(let error):
                    self?.errorSubject.send(error)
                    return nil
                }
            }.eraseToAnyPublisher()
    }
    
    func logout() {
        repository.logout()
    }
    
    func getErrorSubject() -> AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}
