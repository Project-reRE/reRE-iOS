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
}
