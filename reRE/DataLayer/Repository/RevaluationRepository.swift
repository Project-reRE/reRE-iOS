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
    private var paginationModel: PaginationModel = PaginationModel()
    
    init(remoteDataFetcher: RemoteDataFetchable) {
        self.remoteDataFetcher = remoteDataFetcher
    }
}

extension RevaluationRepository: RevaluationRepositoryProtocol {
    func checkAlreadyRevaluated(withId movieId: String) -> AnyPublisher<Result<MyHistoryEntityData, Error>, Never> {
        return remoteDataFetcher.checkAlreadyRevaluated(withId: movieId)
    }
    
    func getMovieDetail(withId movieId: String) -> AnyPublisher<Result<MovieDetailEntity, Error>, Never> {
        return remoteDataFetcher.getMovieDetail(withId: movieId)
    }
    
    func revaluate(with reqestModel: RevaluateRequestModel) -> AnyPublisher<Result<Void, Error>, Never> {
        return remoteDataFetcher.revaluate(with: reqestModel)
    }
    
    func updateRevaluation(withId revaluationId: String, updatedModel: RevaluateRequestModel) -> AnyPublisher<Result<MyHistoryEntityData, Error>, Never> {
        return remoteDataFetcher.updateRevaluation(withId: revaluationId, updatedModel: updatedModel)
    }
    
    func getOtherRevaluations(with model: OtherRevaluationsRequestModel) -> AnyPublisher<Result<OtherRevaluationsEntity, Error>, Never> {
        var moderatedModel: OtherRevaluationsRequestModel = model
        moderatedModel.limit = paginationModel.limit
        moderatedModel.page = paginationModel.page
        
        return remoteDataFetcher.getOtherRevaluations(with: moderatedModel)
    }
    
    func updateRevaluationLikes(withId revaluationId: String, isLiked: Bool) -> AnyPublisher<Result<String, Error>, Never> {
        return remoteDataFetcher.updateRevaluationLikes(withId: revaluationId, isLiked: isLiked)
    }
}
