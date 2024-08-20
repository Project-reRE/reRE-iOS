//
//  HistoryRepositoryProtocol.swift
//  reRE
//
//  Created by 강치훈 on 8/18/24.
//

import Foundation
import Combine

protocol HistoryRepositoryProtocol: AnyObject {
    func getMyHistory(with model: MyHistoryRequestModel) -> AnyPublisher<Result<MyHistoryEntity, Error>, Never>
}
