//
//  SignUpRequestModel.swift
//  reRE
//
//  Created by 강치훈 on 7/10/24.
//

import Foundation

struct SignUpRequestModel: Encodable {
    let provider: String
    let gender: String?
    let birthDate: String?
}
