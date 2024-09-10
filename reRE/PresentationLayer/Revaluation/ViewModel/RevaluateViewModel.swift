//
//  RevaluateViewModel.swift
//  reRE
//
//  Created by 강치훈 on 8/15/24.
//

import Foundation
import Combine

final class RevaluateViewModel: BaseViewModel {
    private var revaluateRequestModel: RevaluateRequestModel = .init()
    
    private let revaluationSuccess = PassthroughSubject<Void, Never>()
    
    private let usecase: RevaluationUsecaseProtocol
    private let movieEntity: MovieDetailEntity
    
    init(usecase: RevaluationUsecaseProtocol, movieEntity: MovieDetailEntity) {
        self.usecase = usecase
        self.movieEntity = movieEntity
        super.init(usecase: usecase)
        
        revaluateRequestModel.movieId = movieEntity.id
    }
    
    func getMovieEntity() -> MovieDetailEntity {
        return movieEntity
    }
    
    func updateRating(to rating: Double) {
        revaluateRequestModel.numStars = rating
    }
    
    func updateSpecialPoint(with point: RevaluationCategoryView.CategoryType) {
        revaluateRequestModel.specialPoint = point.rawValue
    }
    
    func updatePastFeelings(with feelings: RevaluationCategoryView.CategoryType) {
        revaluateRequestModel.pastValuation = feelings.rawValue
    }
    
    func updateCurrentFeelings(with feelings: RevaluationCategoryView.CategoryType) {
        revaluateRequestModel.presentValuation = feelings.rawValue
    }
    
    func updateComment(with comment: String) {
        revaluateRequestModel.comment = comment
    }
    
    func checkMissingCategory() -> RevaluateRequestModel.RevaluateCategory? {
        return revaluateRequestModel.missingCategory()
    }
    
    func revaluate() {
        usecase.revaluate(with: revaluateRequestModel)
            .sink { [weak self] _ in
                self?.revaluationSuccess.send(())
            }.store(in: &cancelBag)
    }
    
    func getRevaluationSuccessPublisher() -> AnyPublisher<Void, Never> {
        return revaluationSuccess.eraseToAnyPublisher()
    }
}
