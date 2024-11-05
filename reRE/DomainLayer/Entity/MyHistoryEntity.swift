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
    let presentValuation: String
    let comment: String
    let createdAt: String
    let updatedAt: String
    let deletedAt: String
    let movie: SearchMovieListResultEntity
    
    init(id: String,
         numStars: String,
         specialPoint: String,
         pastValuation: String,
         presentValuation: String,
         comment: String,
         createdAt: String,
         updatedAt: String,
         deletedAt: String,
         movie: SearchMovieListResultEntity) {
        self.id = id
        self.numStars = numStars
        self.specialPoint = specialPoint
        self.pastValuation = pastValuation
        self.presentValuation = presentValuation
        self.comment = comment
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.movie = movie
    }
    
    init() {
        id = ""
        numStars = ""
        specialPoint = ""
        pastValuation = ""
        presentValuation = ""
        comment = ""
        createdAt = ""
        updatedAt = ""
        deletedAt = ""
        movie = .init()
    }
}
