//
//  RemoteMyProfileItem.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation

struct RemoteMyProfileItem: Decodable {
    let id: String?
    let externalId: String?
    let nickName: String?
    let description: String?
    let profileUrl: String?
    let email: String?
    let provider: String?
    let role: String?
    let gender: Bool?
    let birthDate: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
}