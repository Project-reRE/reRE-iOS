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
    
    private let mapper = ProfileMapper()
    
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
}

extension HistoryUsecase: HistoryUsecaseProtocol {
    func getErrorSubject() -> AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
}
