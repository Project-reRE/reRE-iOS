//
//  SignUpRequestModel.swift
//  reRE
//
//  Created by 강치훈 on 7/10/24.
//

import Foundation

struct SignUpRequestModel: Encodable {
    let nickName: String
    let password: String
    let externalId: String
    let profileUrl: String
    let email: String
    let description: String
    let gender: Bool
    let birthDate: String
}
