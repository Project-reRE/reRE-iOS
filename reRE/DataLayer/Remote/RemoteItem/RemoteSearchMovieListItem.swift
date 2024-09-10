//
//  RemoteSearchMovieListItem.swift
//  reRE
//
//  Created by 강치훈 on 7/29/24.
//

import Foundation

struct RemoteSearchMovieListItem: Decodable {
    let totalRecords: Int?
    let results: [RemoteSearchMovieListResult]?
}

struct RemoteSearchMovieListResult: Decodable {
    let id: String?
    let data: RemoteSearchMovieListData?
}

struct RemoteSearchMovieListData: Decodable {
    let title: String?
    let prodYear: String?
    let titrepRlsDatele: String?
    let directors: [RemoteMovieDirectorDetailData]?
    let actors: [RemoteMovieActorDetailData]?
    let rating: String?
    let genre: String?
    let posters: [String]?
    let stills: [String]?
}
