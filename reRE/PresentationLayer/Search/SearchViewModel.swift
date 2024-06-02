//
//  SearchViewModel.swift
//  reRE
//
//  Created by chihoooon on 2024/06/02.
//

import Foundation
import Combine

final class SearchViewModel {
    private var cancelBag = Set<AnyCancellable>()
    
    private let shouldSearchMovie = PassthroughSubject<String, Never>()
    private let searchResult = CurrentValueSubject<[String], Never>([])
    
    init() {
        bind()
    }
    
    private func bind() {
        shouldSearchMovie
            .sink { [weak self] title in
                let mockData: [String] = Array(repeating: "\(Int.random(in: 0...10))", count: Int.random(in: 0...10))
                self?.searchResult.send(mockData)
            }.store(in: &cancelBag)
    }
    
    func searchMovie(withTitle title: String) {
        shouldSearchMovie.send(title)
    }
    
    func getSearchResultPublisher() -> AnyPublisher<[String], Never> {
        return searchResult.eraseToAnyPublisher()
    }
    
    func getSearchResultValue() -> [String] {
        return searchResult.value
    }
}
