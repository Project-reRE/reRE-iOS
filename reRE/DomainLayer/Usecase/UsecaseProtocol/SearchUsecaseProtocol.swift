//
//  SearchUsecaseProtocol.swift
//  reRE
//
//  Created by 강치훈 on 7/29/24.
//

import Foundation
import Combine

protocol SearchUsecaseProtocol: BaseUsecaseProtocol {
    func searchMovieList(with model: SearchMovieListRequestModel) -> AnyPublisher<SearchMovieListResponseModel, Never>
}
