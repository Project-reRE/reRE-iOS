//
//  RevaluationRepository.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import Foundation
import Combine

final class RevaluationRepository {
    private let remoteDataFetcher: RemoteDataFetchable
    
    init(remoteDataFetcher: RemoteDataFetchable) {
        self.remoteDataFetcher = remoteDataFetcher
    }
}

extension RevaluationRepository: RevaluationRepositoryProtocol {
    func getMovieDetail(withId movieId: String) -> AnyPublisher<Result<MovieDetailEntity, any Error>, Never> {
        return remoteDataFetcher.getMovieDetail(withId: movieId)
    }
    
    func revaluate(with reqestModel: RevaluateRequestModel) -> AnyPublisher<Result<Void, any Error>, Never> {
        return remoteDataFetcher.revaluate(with: reqestModel)
    }
}
