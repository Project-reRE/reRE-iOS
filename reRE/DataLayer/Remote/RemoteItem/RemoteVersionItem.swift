//
//  RemoteVersionItem.swift
//  reRE
//
//  Created by 강치훈 on 11/7/24.
//

import Foundation

struct RemoteVersionItem: Decodable {
    let platform: String?
    let stableVersion: String?
    let minimumVersion: String?
}
