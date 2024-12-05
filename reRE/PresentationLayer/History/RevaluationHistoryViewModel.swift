//
//  RevaluationHistoryViewModel.swift
//  reRE
//
//  Created by 강치훈 on 9/24/24.
//

import Foundation
import Combine

final class RevaluationHistoryViewModel: BaseViewModel {
    private let deletedHistory = PassthroughSubject<Void, Never>()
    
    var deletedHistoryPublisher: AnyPublisher<Void, Never> {
        return deletedHistory.eraseToAnyPublisher()
    }
    
    private let usecase: HistoryUsecaseProtocol
    private let historyEntity: MyHistoryEntityData
    
    init(usecase: HistoryUsecaseProtocol, historyEntity: MyHistoryEntityData) {
        self.usecase = usecase
        self.historyEntity = historyEntity
        
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        
    }
    
    func deleteHistory() {
        usecase.deleteRevaluation(withId: historyEntity.id)
            .sink { [weak self] _ in
                self?.deletedHistory.send(())
            }.store(in: &cancelBag)
    }
    
    func getHistoryEntityValue() -> MyHistoryEntityData {
        return historyEntity
    }
}
