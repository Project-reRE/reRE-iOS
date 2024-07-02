//
//  RankUsecase.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation
import Combine

final class RankUsecase {
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    private let mapper = BannerMapper()
    
    private let repository: RankRepositoryProtocol
    
    init(repository: RankRepositoryProtocol) {
        self.repository = repository
    }
}

extension RankUsecase: RankUsecaseProtocol {
    func getMovieSets() -> AnyPublisher<[MovieSetsResponseModel], Never> {
        return repository.getMovieSets()
            .compactMap { [weak self] result in
                switch result {
                case .success(let entity):
                    return self?.mapper.movieSetsEntityToModel(entity: entity)
                case .failure(let error):
                    self?.errorSubject.send(error)
                    return nil
                }
            }.eraseToAnyPublisher()
    }
    
    func getBannerList() -> AnyPublisher<[BannerResponseModel], Never> {
        return repository.getBannerList()
            .compactMap { [weak self] result in
                switch result {
                case .success(let entity):
                    return self?.mapper.bannerEntityToModel(entity: entity)
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
