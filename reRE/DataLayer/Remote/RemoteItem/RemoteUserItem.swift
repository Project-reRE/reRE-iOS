//
//  RemoteUserItem.swift
//  reRE
//
//  Created by 강치훈 on 9/11/24.
//

import Foundation

struct RemoteUserItem: Decodable {
    let id: String?
    let externalId: String?
    let nickName: String?
    let description: String?
    let profileUrl: String?
    let email: String?
    let provider: String?
    let role: String?
    let gender: String?
    let birthDate: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let statistics: RemoteMyStatisticsItem?
}

struct RemoteMyStatisticsItem: Decodable {
    let id: String?
    let numRevaluations: Int?
}
