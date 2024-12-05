//
//  RevaluationDetailRequestModel.swift
//  reRE
//
//  Created by 강치훈 on 8/18/24.
//

import Foundation

struct RevaluationDetailRequestModel {
    let movieId: String
    let userId: String?
    let startDate: String
    let endDate: String
    let limit: String
    let page: String
}
