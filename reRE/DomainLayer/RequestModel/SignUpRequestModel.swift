//
//  SignUpRequestModel.swift
//  reRE
//
//  Created by 강치훈 on 7/10/24.
//

import Foundation

struct SignUpRequestModel: Encodable {
    let provider: String
    let profileUrl: String?
    let description: String
    let gender: Bool
    let birthDate: String
}
