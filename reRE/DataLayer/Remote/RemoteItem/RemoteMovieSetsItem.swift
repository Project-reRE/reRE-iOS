//
//  RemoteMovieSetsItem.swift
//  reRE
//
//  Created by 강치훈 on 7/2/24.
//

import Foundation

struct RemoteMovieSetsItem: Decodable {
    let totalRecords: Int?
    let results: [RemoteMovieSetsData]?
}

struct RemoteMovieSetsData: Decodable {
    let title: String?
    let template: String?
    let displayOrder: Int?
    let condition: String?
    let data: [RemoteMovieSetData]?
}

struct RemoteMovieSetData: Decodable {
    let DOCID: String?
    let movieId: String?
    let movieSeq: String?
    let title: String?
    let prodYear: String?
    let directors: RemoteMovieDirectorData?
    let actors: RemoteMovieActorData?
    let nation: String?
    let company: String?
    let runtime: String?
    let rating: String?
    let genre: String?
    let repRatDate: String?
    let repRlsDate: String?
    let posters: String?
    let stlls: String?
}

struct RemoteMovieDirectorData: Decodable {
    let director: [RemoteMovieDirectorDetailData]?
}

struct RemoteMovieDirectorDetailData: Decodable {
    let directorNm: String?
    let directorEnNm: String?
    let directorId: String?
}

struct RemoteMovieActorData: Decodable {
    let actor: [RemoteMovieActorDetailData]?
}

struct RemoteMovieActorDetailData: Decodable {
    let actorNm: String?
    let actorEnNm: String?
    let actorId: String?
}
