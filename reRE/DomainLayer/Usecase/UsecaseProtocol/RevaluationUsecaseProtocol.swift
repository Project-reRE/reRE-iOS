//
//  RevaluationUsecaseProtocol.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import Foundation
import Combine

protocol RevaluationUsecaseProtocol: BaseUsecaseProtocol {
    func getMovieDetail(withId movieId: String) -> AnyPublisher<MovieDetailEntity, Never>
}
