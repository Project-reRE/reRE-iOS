//
//  SearchRepository.swift
//  reRE
//
//  Created by 강치훈 on 7/29/24.
//

import Foundation
import Combine

final class SearchRepository {
    private let remoteDataFetcher: RemoteDataFetchable
    
    init(remoteDataFetcher: RemoteDataFetchable) {
        self.remoteDataFetcher = remoteDataFetcher
    }
}

extension SearchRepository: SearchRepositoryProtocol {
    func searchMovieList(with model: SearchMovieListRequestModel) -> AnyPublisher<Result<SearchMovieListEntity, Error>, Never> {
        return remoteDataFetcher.searchMovieList(with: model)
    }
}
