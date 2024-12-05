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
    
    func getRevaluationDetail(of date: String) {
        usecase.getMovieDetail(withId: movieId, date: date)
            .sink { [weak self] movieDetailEntity in
                self?.revaluationData.send(movieDetailEntity)
                
                if let currentMonthData = movieDetailEntity.statistics.first?.numRecentStars.first(where: { $0.currentDate == date }) {
                    self?.showingRatingData.send(currentMonthData)
                }
            }.store(in: &cancelBag)
    }
    
    func getPrevMonthRevaluation() {
        guard let prevMonth = showingRatingData.value.currentDate.toDate(with: "yyyy-MM")?.oneMonthBefore else { return }
        getRevaluationDetail(of: prevMonth.dateToString(with: "yyyy-MM"))
    }
    
    func getNextMonthRevaluation() {
        guard let nextMonth = showingRatingData.value.currentDate.toDate(with: "yyyy-MM")?.oneMonthLater,
              nextMonth < Date() else {
            return
        }
        
        getRevaluationDetail(of: nextMonth.dateToString(with: "yyyy-MM"))
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
