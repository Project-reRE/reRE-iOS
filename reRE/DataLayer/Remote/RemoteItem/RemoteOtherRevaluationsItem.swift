//
//  RemoteOtherRevaluationsItem.swift
//  reRE
//
//  Created by 강치훈 on 9/11/24.
//

import Foundation

struct RemoteOtherRevaluationsItem: Decodable {
    let totalRecords: Int?
    let results: [RemoteOtherRevaluationData]?
}

struct RemoteOtherRevaluationData: Decodable {
    let id: String?
    let numStars: Double?
    let specialPoint: String?
    let pastValuation: String?
    let presentValuation: String?
    let comment: String?
    let createdAt: String?
    let updatedAt: String?
    let user: RemoteUserItem?
    let statistics: RemoteOtherRevaluationStatisticsData?
    let isLiked: Bool?
}

struct RemoteOtherRevaluationStatisticsData: Decodable {
    let id: String?
    let numCommentLikes: Int?
}
