//
//  ReValuationDetailViewModel.swift
//  reRE
//
//  Created by chihoooon on 2024/06/06.
//

import Foundation
import Combine

final class ReValuationDetailViewModel {
    private var cancelBag = Set<AnyCancellable>()
    
    private let shouldLoadRevaluation = CurrentValueSubject<String, Never>(Date().dateToString(with: "yyyy.MM"))
    private let revaluationData = CurrentValueSubject<String, Never>("")
    
    private let movieId: String
    
    init(movieId: String) {
        self.movieId = movieId
        bind()
    }
    
    private func bind() {
        shouldLoadRevaluation
            .sink { [weak self] dateString in
                self?.revaluationData.send(dateString)
            }.store(in: &cancelBag)
    }
    
    func getPrevMonthRevaluation() {
        let showingDate = shouldLoadRevaluation.value
        let prevMonth = showingDate.toDate(with: "yyyy.MM")?.oneMonthBefore
        
        guard let prevMonthString = prevMonth?.dateToString(with: "yyyy.MM") else { return }
        shouldLoadRevaluation.send(prevMonthString)
    }
    
    func getNextMonthRevaluation() {
        let showingDate = shouldLoadRevaluation.value
        let nextMonth = showingDate.toDate(with: "yyyy.MM")?.oneMonthLater
        
        guard let nextMonthString = nextMonth?.dateToString(with: "yyyy.MM") else { return }
        shouldLoadRevaluation.send(nextMonthString)
    }
    
    func getRevaluationDataPublisher() -> AnyPublisher<String, Never> {
        return revaluationData.eraseToAnyPublisher()
    }
    
    func getShowingDateValue() -> AnyPublisher<String, Never> {
        return shouldLoadRevaluation.eraseToAnyPublisher()
    }
}
