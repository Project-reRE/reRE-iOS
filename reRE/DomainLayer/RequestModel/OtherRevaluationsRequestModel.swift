//
//  OtherRevaluationsRequestModel.swift
//  reRE
//
//  Created by 강치훈 on 10/20/24.
//

import Foundation

struct OtherRevaluationsRequestModel {
    let movieId: String
    let isPopularityOrder: Bool
    var page: Int
    var limit: Int
}
