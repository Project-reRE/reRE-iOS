//
//  OtherRevaluationsViewModel.swift
//  reRE
//
//  Created by 강치훈 on 9/7/24.
//

import Foundation

final class OtherRevaluationsViewModel: BaseViewModel {
    private let usecase: RevaluationUsecaseProtocol
    private let movieId: String
    
    init(usecase: RevaluationUsecaseProtocol, movieId: String) {
        self.usecase = usecase
        self.movieId = movieId
        
        super.init(usecase: usecase)
    }
}
