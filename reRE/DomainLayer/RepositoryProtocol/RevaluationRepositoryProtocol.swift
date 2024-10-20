//
//  RevaluationRepositoryProtocol.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import Foundation
import Combine

protocol RevaluationRepositoryProtocol: AnyObject {
    func getMovieDetail(withId movieId: String) -> AnyPublisher<Result<MovieDetailEntity, Error>, Never>
    func revaluate(with reqestModel: RevaluateRequestModel) -> AnyPublisher<Result<Void, Error>, Never>
    func getOtherRevaluations(with model: OtherRevaluationsRequestModel) -> AnyPublisher<Result<OtherRevaluationsEntity, Error>, Never>
    func updateRevaluationLikes(withId revaluationId: String, isLiked: Bool) -> AnyPublisher<Result<String, Error>, Never>
}
