//
//  ReValuationDetailViewModel.swift
//  reRE
//
//  Created by chihoooon on 2024/06/06.
//

import Foundation
import Combine

final class ReValuationDetailViewModel: BaseViewModel {
    private let revaluationData = CurrentValueSubject<MovieDetailEntity, Never>(.init())
    private let showingRatingData = CurrentValueSubject<MovieRecentRatingsEntity, Never>(.init())
    
    private let movieId: String
    
    private let usecase: RevaluationUsecaseProtocol
    
    init(usecase: RevaluationUsecaseProtocol, movieId: String) {
        self.usecase = usecase
        self.movieId = movieId
        
        super.init(usecase: usecase)
        print("movieId: \(movieId)")
        bind()
    }
    
    private func bind() {
        
    }
    
    func getRevaluationDetail() {
        usecase.getMovieDetail(withId: movieId)
            .sink { [weak self] movieDetailEntity in
                self?.revaluationData.send(movieDetailEntity)
                
                if let currentMonthData = movieDetailEntity.statistics.first?.numRecentStars.first(where: { $0.targetDate == Date().oneMonthBefore?.dateToString(with: "yyyy-MM") }) {
                    self?.showingRatingData.send(currentMonthData)
                }
            }.store(in: &cancelBag)
    }
    
    func getPrevMonthRevaluation() {
        let prevMonth = showingRatingData.value.targetDate.toDate(with: "yyyy-MM")?.oneMonthBefore
        
        guard let prevMonthString = prevMonth?.dateToString(with: "yyyy-MM") else { return }
        guard let prevMonthData = revaluationData.value.statistics.first?.numRecentStars.first(where: { $0.targetDate == prevMonthString }) else { return }
        
        showingRatingData.send(prevMonthData)
    }
    
    func getNextMonthRevaluation() {
        let nextMonth = showingRatingData.value.targetDate.toDate(with: "yyyy-MM")?.oneMonthLater
        
        guard let nextMonthString = nextMonth?.dateToString(with: "yyyy-MM") else { return }
        guard let nextMonthData = revaluationData.value.statistics.first?.numRecentStars.first(where: { $0.targetDate == nextMonthString }) else { return }
        
        showingRatingData.send(nextMonthData)
    }
    
    func getRevaluationDataPublisher() -> AnyPublisher<MovieDetailEntity, Never> {
        return revaluationData.eraseToAnyPublisher()
    }
    
    func getShowingDateValue() -> AnyPublisher<MovieRecentRatingsEntity, Never> {
        return showingRatingData.eraseToAnyPublisher()
    }
}
