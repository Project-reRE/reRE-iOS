//
//  HistoryRepository.swift
//  reRE
//
//  Created by 강치훈 on 8/18/24.
//

import Foundation
import Combine

final class HistoryRepository {
    private let remoteDataFetcher: RemoteDataFetchable
    
    init(remoteDataFetcher: RemoteDataFetchable) {
        self.remoteDataFetcher = remoteDataFetcher
    }
}

extension HistoryRepository: HistoryRepositoryProtocol {
    
}
