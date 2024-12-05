//
//  RevaluationRepositoryProtocol.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import Foundation
import Combine

protocol RevaluationRepositoryProtocol: AnyObject {
    func checkAlreadyRevaluated(withId movieId: String) -> AnyPublisher<Result<MyHistoryEntityData?, Error>, Never>
    func getMovieDetail(withId movieId: String) -> AnyPublisher<Result<MovieDetailEntity, Error>, Never>
    func revaluate(with reqestModel: RevaluateRequestModel) -> AnyPublisher<Result<Void, Error>, Never>
    func updateRevaluation(withId revaluationId: String, updatedModel: RevaluateRequestModel) -> AnyPublisher<Result<MyHistoryEntityData, Error>, Never>
    func getOtherRevaluations(with model: OtherRevaluationsRequestModel) -> AnyPublisher<Result<OtherRevaluationsEntity, Error>, Never>
    func updateRevaluationLikes(withId revaluationId: String, isLiked: Bool) -> AnyPublisher<Result<String, Error>, Never>
    func reportRevaluation(withId revaluationId: String, responseNumber: Int) -> AnyPublisher<Result<Void, Error>, Never>
}
