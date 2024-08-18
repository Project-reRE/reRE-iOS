//
//  RemoteBannerItem.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation

struct RemoteBannerItem: Decodable {
    let totalRecords: Int?
    let results: [RemoteBannerData]?
}

struct RemoteBannerData: Decodable {
    let displayOrder: Int?
    let imageUrl: String?
    let route: String?
}
