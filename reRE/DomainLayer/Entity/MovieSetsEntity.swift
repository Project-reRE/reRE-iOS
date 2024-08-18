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
    let id: String
    let data: MovieEntity
}

struct MovieEntity {
    let title: String
    let genre: String
    let repRlsDate: String
    let directors: [MovieDirectorDetailEntity]
    let actors: [MovieActorDetailEntity]
    let posters: [String]
    let stlls: [String]
}

struct MovieDirectorDetailEntity {
    let directorNm: String
    let directorEnNm: String
    let directorId: String
}

struct MovieActorDetailEntity {
    let actorNm: String
    let actorEnNm: String
    let actorId: String
}
