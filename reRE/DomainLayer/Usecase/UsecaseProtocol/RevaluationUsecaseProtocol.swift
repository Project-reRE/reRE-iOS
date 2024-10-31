//
//  RevaluationUsecaseProtocol.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import Foundation
import Combine

protocol RevaluationUsecaseProtocol: BaseUsecaseProtocol {
    func checkAlreadyRevaluated(withId movieId: String) -> AnyPublisher<MyHistoryEntityData, Never>
    func getMovieDetail(withId movieId: String) -> AnyPublisher<MovieDetailEntity, Never>
    func revaluate(with reqestModel: RevaluateRequestModel) -> AnyPublisher<Void, Never>
    func getOtherRevaluations(with model: OtherRevaluationsRequestModel) -> AnyPublisher<OtherRevaluationsEntity, Never>
    func updateRevaluationLikes(withId revaluationId: String, isLiked: Bool) -> AnyPublisher<String, Never>
}
