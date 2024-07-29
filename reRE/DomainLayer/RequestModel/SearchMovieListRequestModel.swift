//
//  SearchMovieListRequestModel.swift
//  reRE
//
//  Created by 강치훈 on 7/29/24.
//

import Foundation

struct SearchMovieListRequestModel {
    let title: String
    let limit: Int
    
    init(title: String, limit: Int) {
        self.title = title
        self.limit = limit
    }
    
    init() {
        title = ""
        limit = 0
    }
}
