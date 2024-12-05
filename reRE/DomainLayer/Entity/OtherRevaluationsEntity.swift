//
//  OtherRevaluationsEntity.swift
//  reRE
//
//  Created by 강치훈 on 9/11/24.
//

import Foundation

struct OtherRevaluationsEntity {
    let totalRecords: Int
    let results: [OtherRevaluationEntity]
}

struct OtherRevaluationEntity {
    let id: String
    let numStars: Double
    let specialPoint: String
    let pastValuation: String
    let presentValuation: String
    let comment: String
    let createdAt: String
    let updatedAt: String
    let user: UserEntity
    var statistics: OtherRevaluationStatisticsEntity
    var isLiked: Bool
    
    init(id: String,
         numStars: Double,
         specialPoint: String,
         pastValuation: String,
         presentValuation: String,
         comment: String,
         createdAt: String,
         updatedAt: String,
         user: UserEntity,
         statistics: OtherRevaluationStatisticsEntity,
         isLiked: Bool) {
        self.id = id
        self.numStars = numStars
        self.specialPoint = specialPoint
        self.pastValuation = pastValuation
        self.presentValuation = presentValuation
        self.comment = comment
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.user = user
        self.statistics = statistics
        self.isLiked = isLiked
    }
    
    init() {
        id = ""
        numStars = 0
        specialPoint = ""
        pastValuation = ""
        presentValuation = ""
        comment = ""
        createdAt = ""
        updatedAt = ""
        user = .init()
        statistics = .init()
        isLiked = false
    }
}

struct OtherRevaluationStatisticsEntity {
    let id: String
    var numCommentLikes: Int
    
    init(id: String, numCommentLikes: Int) {
        self.id = id
        self.numCommentLikes = numCommentLikes
    }
    
    init() {
        id = ""
        numCommentLikes = 0
    }
}
