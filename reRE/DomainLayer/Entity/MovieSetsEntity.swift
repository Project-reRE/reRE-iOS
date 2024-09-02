//
//  MovieSetsEntity.swift
//  reRE
//
//  Created by 강치훈 on 7/2/24.
//

import Foundation

struct MovieSetsEntity {
    let title: String
    let genre: String
    let template: String
    let displayOrder: Int
    let condition: String
    let data: [MovieSetEntity]
    
    init(title: String, genre: String, template: String, displayOrder: Int, condition: String, data: [MovieSetEntity]) {
        self.title = title
        self.genre = genre
        self.template = template
        self.displayOrder = displayOrder
        self.condition = condition
        self.data = data
    }
    
    init() {
        title = ""
        genre = ""
        template = ""
        displayOrder = 0
        condition = ""
        data = []
    }
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
