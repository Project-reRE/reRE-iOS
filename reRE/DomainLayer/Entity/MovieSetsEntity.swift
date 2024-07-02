//
//  MovieSetsEntity.swift
//  reRE
//
//  Created by 강치훈 on 7/2/24.
//

import Foundation

struct MovieSetsEntity {
    let title: String
    let template: String
    let displayOrder: Int
    let condition: String
    let data: [MovieSetEntity]
}

struct MovieSetEntity {
    let DOCID: String
    let movieId: String
    let movieSeq: String
    let title: String
    let prodYear: String
    let directors: MovieDirectorEntity
    let actors: MovieActorEntity
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

struct MovieDirectorEntity {
    let director: [MovieDirectorDetailEntity]
}

struct MovieDirectorDetailEntity {
    let directorNm: String
    let directorEnNm: String
    let directorId: String
}

struct MovieActorEntity {
    let actor: [MovieActorDetailEntity]
}

struct MovieActorDetailEntity {
    let actorNm: String
    let actorEnNm: String
    let actorId: String
}
