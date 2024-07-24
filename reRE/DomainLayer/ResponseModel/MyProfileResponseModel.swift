//
//  MyProfileResponseModel.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation

struct MyProfileResponseModel {
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
         deletedAt: String) {
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
    }
}
