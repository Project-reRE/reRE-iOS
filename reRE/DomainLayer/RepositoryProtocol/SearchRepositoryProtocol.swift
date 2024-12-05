//
//  SearchRepositoryProtocol.swift
//  reRE
//
//  Created by 강치훈 on 7/29/24.
//

import Foundation
import Combine

protocol SearchRepositoryProtocol: AnyObject {
    func searchMovieList(with model: SearchMovieListRequestModel) -> AnyPublisher<Result<SearchMovieListEntity, Error>, Never>
}
