//
//  LoginResponseModel.swift
//  reRE
//
//  Created by 강치훈 on 7/10/24.
//

import Foundation

struct LoginResponseModel {
    let statusCode: Int
    let code: String
    let message: [String]
    let jwt: String
}
