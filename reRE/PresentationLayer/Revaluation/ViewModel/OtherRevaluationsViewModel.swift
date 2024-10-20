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
    private(set) var isPopularityOrder: Bool = true
    
    private let usecase: RevaluationUsecaseProtocol
    private let movieId: String
    
    init(usecase: RevaluationUsecaseProtocol, movieId: String) {
        self.usecase = usecase
        self.movieId = movieId
        
        super.init(usecase: usecase)
    }
    
    func getOtherRevaluations() {
        usecase.getOtherRevaluations(with: .init(movieId: movieId,
                                                 isPopularityOrder: isPopularityOrder,
                                                 page: 0,
                                                 limit: 0))
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
    
    func updateRevaluationLikes(withId revaluationId: String, isLiked: Bool) {
        usecase.updateRevaluationLikes(withId: revaluationId, isLiked: isLiked)
            .mainSink { [weak self] _ in
                guard let self = self else { return }
                guard let index = self.otherRevaluations.value.firstIndex(where: { $0.id == revaluationId }) else { return }
                
                var updatedRevaluation: OtherRevaluationEntity = self.otherRevaluations.value[index]
                updatedRevaluation.isLiked = isLiked
                
                if isLiked {
                    updatedRevaluation.statistics.numCommentLikes += 1
                } else {
                    updatedRevaluation.statistics.numCommentLikes -= 1
                }
                
                self.otherRevaluations.value[index] = updatedRevaluation
            }.store(in: &cancelBag)
    }
    
    func changeOrder() {
        isPopularityOrder.toggle()
        getOtherRevaluations()
    }
}
