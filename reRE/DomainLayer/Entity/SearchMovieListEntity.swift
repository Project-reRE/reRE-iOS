//
//  SearchMovieListEntity.swift
//  reRE
//
//  Created by 강치훈 on 7/29/24.
//

import Foundation

struct SearchMovieListEntity {
    let totalRecords: Int
    let results: [SearchMovieListResultEntity]
    
    init(totalRecords: Int, results: [SearchMovieListResultEntity]) {
        self.totalRecords = totalRecords
        self.results = results
    }
    
    init() {
        totalRecords = 0
        results = []
    }
}

struct SearchMovieListResultEntity {
    let id: String
    let data: SearchMovieListDataEntity
    
    init(id: String, data: SearchMovieListDataEntity) {
        self.id = id
        self.data = data
    }
    
    init() {
        id = ""
        data = .init()
    }
}

struct SearchMovieListDataEntity {
    let title: String
    let prodYear: String
    let titrepRlsDatele: String
    let directors: [MovieDirectorDetailEntity]
    let actors: [MovieActorDetailEntity]
    let rating: String
    let genre: String
    let posters: [String]
    let stills: [String]
    
    init(title: String,
         prodYear: String,
         titrepRlsDatele: String,
         directors: [MovieDirectorDetailEntity],
         actors: [MovieActorDetailEntity],
         rating: String,
         genre: String,
         posters: [String],
         stills: [String]) {
        self.title = title
        self.prodYear = prodYear
        self.titrepRlsDatele = titrepRlsDatele
        self.directors = directors
        self.actors = actors
        self.rating = rating
        self.genre = genre
        self.posters = posters
        self.stills = stills
    }
    
    init() {
        title = ""
        prodYear = ""
        titrepRlsDatele = ""
        directors = []
        actors = []
        rating = ""
        genre = ""
        posters = []
        stills = []
    }
}
