//
//  UpdateUserInfoRequestModel.swift
//  reRE
//
//  Created by 강치훈 on 9/18/24.
//

import Foundation

struct UpdateUserInfoRequestModel: Encodable {
    let profileUrl: String?
    let nickName: String?
}
