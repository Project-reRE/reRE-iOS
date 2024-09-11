//
//  OtherRevaluationsViewModel.swift
//  reRE
//
//  Created by 강치훈 on 9/7/24.
//

import Foundation
import Combine

final class OtherRevaluationsViewModel: BaseViewModel {
    private let otherRevaluations = CurrentValueSubject<[OtherRevaluationEntity], Never>([])
    
    private let usecase: RevaluationUsecaseProtocol
    private let movieId: String
    
    init(usecase: RevaluationUsecaseProtocol, movieId: String) {
        self.usecase = usecase
        self.movieId = movieId
        
        super.init(usecase: usecase)
    }
    
    func getOtherRevaluations() {
        usecase.getOtherRevaluations(withId: movieId)
            .mainSink { [weak self] otherRevaluations in
                self?.otherRevaluations.send(otherRevaluations.results)
            }.store(in: &cancelBag)
    }
    
    func getOtherRevaluationsPublisher() -> AnyPublisher<[OtherRevaluationEntity], Never> {
        return otherRevaluations.eraseToAnyPublisher()
    }
    
    func getOtherRevaluationsValue() -> [OtherRevaluationEntity] {
        return otherRevaluations.value
    }
}
