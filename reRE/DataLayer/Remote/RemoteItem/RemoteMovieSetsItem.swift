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
    let genre: String?
    let template: String?
    let displayOrder: Int?
    let condition: String?
    let data: [RemoteMovieSetData]?
}

struct RemoteMovieSetData: Decodable {
    let id: String?
    let data: RemoteMovieData?
}

struct RemoteMovieData: Decodable {
    let title: String?
    let genre: String?
    let repRlsDate: String?
    let directors: [RemoteMovieDirectorDetailData]?
    let actors: [RemoteMovieActorDetailData]?
    let posters: [String]?
    let stlls: [String]?
}

struct RemoteMovieDirectorDetailData: Decodable {
    let directorNm: String?
    let directorEnNm: String?
    let directorId: String?
}

struct RemoteMovieActorDetailData: Decodable {
    let actorNm: String?
    let actorEnNm: String?
    let actorId: String?
}
