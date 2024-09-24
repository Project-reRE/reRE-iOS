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
    let currentDate: String?
    let numSpecialPointTopThree: [RemoteMovieMostSpecialPointItem]?
    let numPastValuationPercent: [RemoteMovieStatisticsPercentageItem]?
    let numPresentValuationPercent: [RemoteMovieStatisticsPercentageItem]?
    let numGenderPercent: [RemoteMovieStatisticsPercentageItem]?
    let numAgePercent: [RemoteMovieStatisticsPercentageItem]?
}

struct RemoteMovieRecentRatingsItem: Decodable {
    let currentDate: String?
    let numStars: String?
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

struct RemoteMovieMostSpecialPointItem: Decodable {
    let rank: Int?
    let type: String?
    let value: Int?
}

struct RemoteMovieStatisticsPercentageItem: Decodable {
    let rank: Int?
    let type: String?
    let value: String?
}
