//
//  HistoryUsecase.swift
//  reRE
//
//  Created by 강치훈 on 8/18/24.
//

import Foundation
import Combine

final class HistoryUsecase {
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    private let repository: HistoryRepositoryProtocol
    
    init(repository: HistoryRepositoryProtocol) {
        self.repository = repository
    }
}

extension HistoryUsecase: HistoryUsecaseProtocol {
    func getMyHistory(with model: MyHistoryRequestModel) -> AnyPublisher<MyHistoryEntity, Never> {
        return repository.getMyHistory(with: model)
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
    
    func getErrorSubject() -> AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}
