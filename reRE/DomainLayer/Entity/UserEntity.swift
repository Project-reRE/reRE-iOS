//
//  UserEntity.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation

struct UserEntity {
    let id: String
    let externalId: String
    let nickName: String
    let description: String
    let profileUrl: String
    let email: String
    let provider: String
    let role: String
    let gender: Bool
    let birthDate: String
    let createdAt: String
    let updatedAt: String
    let deletedAt: String
    let statistics: MyStatisticsEntity
    
    init(id: String,
         externalId: String,
         nickName: String,
         description: String,
         profileUrl: String,
         email: String,
         provider: String,
         role: String,
         gender: Bool,
         birthDate: String,
         createdAt: String,
         updatedAt: String,
         deletedAt: String,
         statistics: MyStatisticsEntity) {
        self.id = id
        self.externalId = externalId
        self.nickName = nickName
        self.description = description
        self.profileUrl = profileUrl
        self.email = email
        self.provider = provider
        self.role = role
        self.gender = gender
        self.birthDate = birthDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.statistics = statistics
    }
    
    init() {
        id = ""
        externalId = ""
        nickName = ""
        description = ""
        profileUrl = ""
        email = ""
        provider = ""
        role = ""
        gender = true
        birthDate = ""
        createdAt = ""
        updatedAt = ""
        deletedAt = ""
        statistics = .init()
    }
}

struct MyStatisticsEntity {
    let id: String
    let numRevaluations: Int
    
    init(id: String, numRevaluations: Int) {
        self.id = id
        self.numRevaluations = numRevaluations
    }
    
    init() {
        id = ""
        numRevaluations = 0
    }
}
