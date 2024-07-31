//
//  HistoryListViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/30/24.
//

import Foundation
import Combine

final class HistoryListViewModel {
    private var cancelBag = Set<AnyCancellable>()
    
    private let shouldLoadRevaluationHistory = CurrentValueSubject<String, Never>(Date().dateToString(with: "yyyy.MM"))
    private let historyList = CurrentValueSubject<[String], Never>([])
    
    init() {
        bind()
    }
    
    private func bind() {
        shouldLoadRevaluationHistory
            .sink { [weak self] _ in
                self?.historyList.send(Array(repeating: "test", count: Int.random(in: 0...50)))
            }.store(in: &cancelBag)
    }
    
    func getPrevMonthHistoryList() {
        let showingDate = shouldLoadRevaluationHistory.value
        let prevMonth = showingDate.toDate(with: "yyyy.MM")?.oneMonthBefore
        
        guard let prevMonthString = prevMonth?.dateToString(with: "yyyy.MM") else { return }
        shouldLoadRevaluationHistory.send(prevMonthString)
    }
    
    func getNextMonthHistoryList() {
        let showingDate = shouldLoadRevaluationHistory.value
        let nextMonth = showingDate.toDate(with: "yyyy.MM")?.oneMonthLater
        
        guard let nextMonthString = nextMonth?.dateToString(with: "yyyy.MM") else { return }
        shouldLoadRevaluationHistory.send(nextMonthString)
    }
    
    func getHistoryListPublisher() -> AnyPublisher<[String], Never> {
        return historyList.eraseToAnyPublisher()
    }
    
    func getHistoryListValue() -> [String] {
        return historyList.value
    }
    
    func getShowingDateValue() -> AnyPublisher<String, Never> {
        return shouldLoadRevaluationHistory.eraseToAnyPublisher()
    }
}
