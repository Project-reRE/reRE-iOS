//
//  SearchViewModel.swift
//  reRE
//
//  Created by chihoooon on 2024/06/02.
//

import Foundation
import Combine

final class SearchViewModel: BaseViewModel {
    private let shouldSearchMovie = CurrentValueSubject<SearchMovieListRequestModel, Never>(.init())
    private let searchResult = CurrentValueSubject<[SearchMovieListResultResponseModel], Never>([])
    
    private let usecase: SearchUsecaseProtocol
    
    init(usecase: SearchUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        shouldSearchMovie
            .dropFirst()
            .flatMap(usecase.searchMovieList(with:))
            .sink { [weak self] searchResponse in
                self?.searchResult.send(searchResponse.results)
            }.store(in: &cancelBag)
    }
    
    func searchMovie(withTitle title: String) {
        shouldSearchMovie.send(SearchMovieListRequestModel(title: title, limit: 25))
    }
    
    func getSearchResultPublisher() -> AnyPublisher<[SearchMovieListResultResponseModel], Never> {
        return searchResult.eraseToAnyPublisher()
    }
    
    func getSearchResultValue() -> [SearchMovieListResultResponseModel] {
        return searchResult.value
    }
}
