//
//  MyHistoryEntity.swift
//  reRE
//
//  Created by 강치훈 on 8/20/24.
//

import Foundation

struct MyHistoryEntity {
    let totalRecords: Int
    let results: [MyHistoryEntityData]
    
    init(totalRecords: Int, results: [MyHistoryEntityData]) {
        self.totalRecords = totalRecords
        self.results = results
    }
    
    init() {
        totalRecords = 0
        results = []
    }
}

struct MyHistoryEntityData {
    let id: String
    let numStars: String
    let specialPoint: String
    let pastValuation: String
    let comment: String
    let createdAt: String
    let updatedAt: String
    let deletedAt: String
    let movie: SearchMovieListResultEntity
}
