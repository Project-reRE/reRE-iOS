//
//  RevaluateViewModel.swift
//  reRE
//
//  Created by 강치훈 on 8/15/24.
//

import Foundation

final class RevaluateViewModel {
    private let movieEntity: SearchMovieListDataEntity
    
    init(movieEntity: SearchMovieListDataEntity) {
        self.movieEntity = movieEntity
    }
    
    func getMovieEntity() -> SearchMovieListDataEntity {
        return movieEntity
    }
}
