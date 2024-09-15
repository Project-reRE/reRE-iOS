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
    func getMovieDetail(withId movieId: String) -> AnyPublisher<Result<MovieDetailEntity, Error>, Never> {
        return remoteDataFetcher.getMovieDetail(withId: movieId)
    }
    
    func revaluate(with reqestModel: RevaluateRequestModel) -> AnyPublisher<Result<Void, Error>, Never> {
        return remoteDataFetcher.revaluate(with: reqestModel)
    }
    
    func getOtherRevaluations(withId movieId: String) -> AnyPublisher<Result<OtherRevaluationsEntity, Error>, Never> {
        return remoteDataFetcher.getOtherRevaluations(withId: movieId)
    }
    
    func updateRevaluationLikes(withId revaluationId: String, isLiked: Bool) -> AnyPublisher<Result<String, Error>, Never> {
        return remoteDataFetcher.updateRevaluationLikes(withId: revaluationId, isLiked: isLiked)
    }
}
