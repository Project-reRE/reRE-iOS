//
//  MovieSetsResponseModel.swift
//  reRE
//
//  Created by 강치훈 on 7/2/24.
//

import Foundation

struct MovieSetsResponseModel {
    let title: String
    let template: String
    let displayOrder: Int
    let condition: String
    let data: [MovieSetResponseModel]
}

struct MovieSetResponseModel {
    let DOCID: String
    let movieId: String
    let movieSeq: String
    let title: String
    let prodYear: String
    let directors: MovieDirectorResponseModel
    let actors: MovieActorResponseModel
    let nation: String
    let company: String
    let runtime: String
    let rating: String
    let genre: String
    let repRatDate: String
    let repRlsDate: String
    let posters: String
    let stlls: String
}

struct MovieDirectorResponseModel {
    let director: [MovieDirectorDetailResponseModel]
}

struct MovieDirectorDetailResponseModel {
    let directorNm: String
    let directorEnNm: String
    let directorId: String
}

struct MovieActorResponseModel {
    let actor: [MovieActorDetailResponseModel]
}

struct MovieActorDetailResponseModel {
    let actorNm: String
    let actorEnNm: String
    let actorId: String
}
