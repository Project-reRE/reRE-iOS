//
//  RemoteLoginItem.swift
//  reRE
//
//  Created by 강치훈 on 7/8/24.
//

import Foundation

struct RemoteLoginItem: Decodable {
    let jwt: String?
}

struct UserError: Error, Decodable {
    let statusCode: Int
    let code: String
    let message: [String]
}
