//
//  HistoryListViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/30/24.
//

import Foundation
import Combine

final class HistoryListViewModel: BaseViewModel {
    private let shouldLoadRevaluationHistory = CurrentValueSubject<MyHistoryRequestModel, Never>(.init(startDate: Date().startDayOfMonthString(),
                                                                                                       endDate: Date().endDayOfMonthString(),
                                                                                                       limit: 25,
                                                                                                       page: 1))
    private let historyList = CurrentValueSubject<MyHistoryEntity, Never>(.init())
    
    private let usecase: HistoryUsecaseProtocol
    
    init(usecase: HistoryUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        shouldLoadRevaluationHistory
            .dropFirst()
            .flatMap(usecase.getMyHistory(with:))
            .sink { [weak self] historyEntity in
                self?.historyList.send(historyEntity)
            }.store(in: &cancelBag)
    }
    
    func fetchRevaluationHistories() {
        shouldLoadRevaluationHistory.send(shouldLoadRevaluationHistory.value)
    }
    
    func getPrevMonthHistoryList() {
        let showingDate = shouldLoadRevaluationHistory.value
        
        guard let prevMonth = showingDate.startDate.toDate(with: "yyyy-MM-dd")?.oneMonthBefore,
              StaticValues.openedMonth <= prevMonth else {
            return
        }
        
        let startDayOfPrevMonthString = prevMonth.startDayOfMonthString()
        let endDayOfPrevMonthString = prevMonth.endDayOfMonthString()
        
        shouldLoadRevaluationHistory.send(.init(startDate: startDayOfPrevMonthString,
                                                endDate: endDayOfPrevMonthString,
                                                limit: 25,
                                                page: 1))
    }
    
    func getNextMonthHistoryList() {
        let showingDate = shouldLoadRevaluationHistory.value
        
        guard let nextMonth = showingDate.startDate.toDate(with: "yyyy-MM-dd")?.oneMonthLater,
              Date() > nextMonth else {
            return
        }
        
        let startDayOfNextMonthString = nextMonth.startDayOfMonthString()
        let endDayOfNextMonthString = nextMonth.endDayOfMonthString()
        
        shouldLoadRevaluationHistory.send(.init(startDate: startDayOfNextMonthString,
                                                endDate: endDayOfNextMonthString,
                                                limit: 25,
                                                page: 1))
    }
    
    func getHistoryListPublisher() -> AnyPublisher<MyHistoryEntity, Never> {
        return historyList.eraseToAnyPublisher()
    }
    
    func getHistoryListValue() -> MyHistoryEntity {
        return historyList.value
    }
    
    func getShowingDateValue() -> AnyPublisher<MyHistoryRequestModel, Never> {
        return shouldLoadRevaluationHistory.eraseToAnyPublisher()
    }
}
