//
//  RevaluationUsecase.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import Foundation
import Combine

final class RevaluationUsecase {
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    private let repository: RevaluationRepositoryProtocol
    
    init(repository: RevaluationRepositoryProtocol) {
        self.repository = repository
    }
}

extension RevaluationUsecase: RevaluationUsecaseProtocol {
    func getMovieDetail(withId movieId: String) -> AnyPublisher<MovieDetailEntity, Never> {
        return repository.getMovieDetail(withId: movieId)
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
    
    func revaluate(with reqestModel: RevaluateRequestModel) -> AnyPublisher<Void, Never> {
        return repository.revaluate(with: reqestModel)
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
    
    func getOtherRevaluations(withId movieId: String) -> AnyPublisher<OtherRevaluationsEntity, Never> {
        return repository.getOtherRevaluations(withId: movieId)
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
