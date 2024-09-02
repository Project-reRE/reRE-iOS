//
//  SearchMovieListResponseModel.swift
//  reRE
//
//  Created by 강치훈 on 7/29/24.
//

import Foundation

struct SearchMovieListResponseModel {
    let totalRecords: Int
    let results: [SearchMovieListResultResponseModel]
}

struct SearchMovieListResultResponseModel {
    let id: String
    let data: SearchMovieListDataResponseModel
}

struct SearchMovieListDataResponseModel {
    let title: String
    let prodYear: String
    let titrepRlsDatele: String
    let directors: [MovieDirectorDetailResponseModel]
    let actors: [MovieActorDetailResponseModel]
    let rating: String
    let genre: String
    let posters: [String]
    let stills: [String]
}
