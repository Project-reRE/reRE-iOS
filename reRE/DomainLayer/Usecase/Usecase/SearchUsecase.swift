//
//  SearchUsecase.swift
//  reRE
//
//  Created by 강치훈 on 7/29/24.
//

import Foundation
import Combine

final class SearchUsecase {
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    private let mapper = SearchMapper()
    
    private let repository: SearchRepositoryProtocol
    
    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
}

extension SearchUsecase: SearchUsecaseProtocol {
    func searchMovieList(with model: SearchMovieListRequestModel) -> AnyPublisher<SearchMovieListResponseModel, Never> {
        return repository.searchMovieList(with: model)
            .compactMap { [weak self] result in
                switch result {
                case .success(let entity):
                    return self?.mapper.searchEntityToModel(entity: entity)
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
