//
//  RemoteMyHistoryItem.swift
//  reRE
//
//  Created by 강치훈 on 8/20/24.
//

import Foundation

struct RemoteMyHistoryItem: Decodable {
    let totalRecords: Int?
    let results: [RemoteMyHistoryData]?
}

struct RemoteMyHistoryData: Decodable {
    let id: String?
    let numStars: String?
    let specialPoint: String?
    let pastValuation: String?
    let presentValuation: String?
    let comment: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let movie: RemoteSearchMovieListResult?
}
