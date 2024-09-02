//
//  MovieSetsResponseModel.swift
//  reRE
//
//  Created by 강치훈 on 7/2/24.
//

import Foundation

struct MovieSetsResponseModel {
    let title: String
    let genre: String
    let template: String
    let displayOrder: Int
    let condition: String
    let data: [MovieSetResponseModel]
}

struct MovieSetResponseModel {
    let id: String
    let data: MovieResponseModel
}

struct MovieResponseModel {
    let title: String
    let genre: String
    let repRlsDate: String
    let directors: [MovieDirectorDetailResponseModel]
    let actors: [MovieActorDetailResponseModel]
    let posters: [String]
    let stlls: [String]
}

struct MovieDirectorDetailResponseModel {
    let directorNm: String
    let directorEnNm: String
    let directorId: String
}

struct MovieActorDetailResponseModel {
    let actorNm: String
    let actorEnNm: String
    let actorId: String
}
