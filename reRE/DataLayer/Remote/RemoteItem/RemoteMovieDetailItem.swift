//
//  RemoteMovieDetailItem.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import Foundation

struct RemoteMovieDetailItem: Decodable {
    let id: String?
    let data: RemoteSearchMovieListData?
    let statistics: [RemoteMovieStatisticsItem]?
}

struct RemoteMovieStatisticsItem: Decodable {
    let id: String?
    let numRecentStars: [RemoteMovieRecentRatingsItem]?
    let numStars: Double?
    let numStarsParticipants: Int?
    let numSpecialPoint: RemoteMovieSpecialPointItem?
    let numPastValuation: RemoteMovieFeelingsItem?
    let numPresentValuation: RemoteMovieFeelingsItem?
    let numGender: RemoteRevaluatedGenderItem?
    let numAge: RemoteRevaluatedAgeItem?
    let targetDate: String?
}

struct RemoteMovieRecentRatingsItem: Decodable {
    let targetDate: String?
    let numStars: Double?
}

struct RemoteMovieSpecialPointItem: Decodable {
    let PLANNING_INTENT: Int?
    let DIRECTORS_DIRECTION: Int?
    let ACTING_SKILLS: Int?
    let SCENARIO: Int?
    let OST: Int?
    let SOCIAL_ISSUES: Int?
    let VISUAL_ELEMENT: Int?
    let SOUND_ELEMENT: Int?
}

struct RemoteMovieFeelingsItem: Decodable {
    let POSITIVE: Int?
    let NEGATIVE: Int?
    let NOT_SURE: Int?
}

struct RemoteRevaluatedGenderItem: Decodable {
    let MALE: Int?
    let FEMALE: Int?
}

struct RemoteRevaluatedAgeItem: Decodable {
    let TEENS: Int?
    let TWENTIES: Int?
    let THIRTIES: Int?
    let FORTIES: Int?
    let FIFTIES_PLUS: Int?
}
