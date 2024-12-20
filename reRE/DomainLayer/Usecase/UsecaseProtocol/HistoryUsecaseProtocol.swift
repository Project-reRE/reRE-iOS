//
//  HistoryUsecaseProtocol.swift
//  reRE
//
//  Created by 강치훈 on 8/18/24.
//

import Foundation
import Combine

protocol HistoryUsecaseProtocol: BaseUsecaseProtocol {
    func getMyHistory(with model: MyHistoryRequestModel) -> AnyPublisher<MyHistoryEntity, Never>
    func deleteRevaluation(withId revaluationId: String) -> AnyPublisher<Void, Never>
}
