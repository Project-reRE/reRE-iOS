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
    private(set) var myHistoryEntity: MyHistoryEntityData?
    
    init(usecase: RevaluationUsecaseProtocol, movieEntity: MovieDetailEntity, myHistoryEntity: MyHistoryEntityData?) {
        self.usecase = usecase
        self.movieEntity = movieEntity
        self.myHistoryEntity = myHistoryEntity
        super.init(usecase: usecase)
        
        revaluateRequestModel.movieId = movieEntity.id
    }
    
    var isOverDate: Bool {
        if movieEntity.statistics.isEmpty {
            let updatedDate = myHistoryEntity?.updatedAt.toDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            let endDayOfMonth = updatedDate?.endDayOfMonth()
            
            return endDayOfMonth ?? Date() < Date()
        } else {
            return Date().dateToString(with: "yyyy-MM") != movieEntity.statistics.first?.currentDate
        }
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
        if let myHistoryEntity = myHistoryEntity {
            usecase.updateRevaluation(withId: myHistoryEntity.id, updatedModel: revaluateRequestModel)
                .sink { [weak self] updatedHistory in
                    NotificationCenter.default.post(name: .revaluationUpdated,
                                                    object: nil,
                                                    userInfo: ["updatedHistory": updatedHistory])
                    self?.revaluationSuccess.send(())
                }.store(in: &cancelBag)
        } else {
            usecase.revaluate(with: revaluateRequestModel)
                .sink { [weak self] _ in
                    NotificationCenter.default.post(name: .revaluationAdded, object: nil)
                    self?.revaluationSuccess.send(())
                }.store(in: &cancelBag)
        }
    }
    
    func getRevaluationSuccessPublisher() -> AnyPublisher<Void, Never> {
        return revaluationSuccess.eraseToAnyPublisher()
    }
}
