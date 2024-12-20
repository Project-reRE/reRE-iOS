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
    private let myHistory = CurrentValueSubject<MyHistoryEntityData?, Never>(nil)
    
    var myHistoryPublisher: AnyPublisher<MyHistoryEntityData?, Never> {
        return myHistory.eraseToAnyPublisher()
    }
    
    var myHistoryValue: MyHistoryEntityData? {
        return myHistory.value
    }
    
    private(set) var currentDate: String = Date().dateToString(with: "MM")
    
    private let usecase: RevaluationUsecaseProtocol
    private let movieId: String
    
    init(usecase: RevaluationUsecaseProtocol, movieId: String) {
        self.usecase = usecase
        self.movieId = movieId
        
        super.init(usecase: usecase)
        bind()
    }
    
    private func bind() {
        
    }
    
    var isOverDate: Bool {
        return Date().dateToString(with: "yyyy-MM") != revaluationData.value.statistics.first?.currentDate
    }
    
    func getMovidId() -> String {
        return movieId
    }
    
    func checkAlreadyRevaluated() {
        if StaticValues.isLoggedIn.value {
            usecase.checkAlreadyRevaluated(withId: movieId)
                .sink { [weak self] myHistory in
                    self?.myHistory.send(myHistory)
                }.store(in: &cancelBag)
        } else {
            myHistory.send(nil)
        }
    }
    
    func getRevaluationDetail() {
        usecase.getMovieDetail(withId: movieId)
            .sink { [weak self] movieDetailEntity in
                self?.revaluationData.send(movieDetailEntity)
                
                if let currentMonthData = movieDetailEntity.statistics.first?.numRecentStars.first(where: { $0.currentDate == Date().dateToString(with: "yyyy-MM") }) {
                    self?.showingRatingData.send(currentMonthData)
                }
            }.store(in: &cancelBag)
    }
    
    func getPrevMonthRevaluation() {
        let prevMonth = showingRatingData.value.currentDate.toDate(with: "yyyy-MM")?.oneMonthBefore
        
        guard let prevMonthString = prevMonth?.dateToString(with: "yyyy-MM") else { return }
        guard let prevMonthData = revaluationData.value.statistics.first?.numRecentStars.first(where: { $0.currentDate == prevMonthString }) else { return }
        
        showingRatingData.send(prevMonthData)
    }
    
    func getNextMonthRevaluation() {
        let nextMonth = showingRatingData.value.currentDate.toDate(with: "yyyy-MM")?.oneMonthLater
        
        guard let nextMonthString = nextMonth?.dateToString(with: "yyyy-MM") else { return }
        guard let nextMonthData = revaluationData.value.statistics.first?.numRecentStars.first(where: { $0.currentDate == nextMonthString }) else { return }
        
        showingRatingData.send(nextMonthData)
    }
    
    func getRevaluationDataPublisher() -> AnyPublisher<MovieDetailEntity, Never> {
        return revaluationData.eraseToAnyPublisher()
    }
    
    func getRevaluationDataValue() -> MovieDetailEntity {
        return revaluationData.value
    }
    
    func getShowingDateValue() -> AnyPublisher<MovieRecentRatingsEntity, Never> {
        return showingRatingData.eraseToAnyPublisher()
    }
}
