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
    let numStars: String?
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
    let PLANNING_INTENT: String?
    let DIRECTORS_DIRECTION: String?
    let ACTING_SKILLS: String?
    let SCENARIO: String?
    let OST: String?
    let SOCIAL_ISSUES: String?
    let VISUAL_ELEMENT: String?
    let SOUND_ELEMENT: String?
}

struct RemoteMovieFeelingsItem: Decodable {
    let POSITIVE: String?
    let NEGATIVE: String?
    let NOT_SURE: String?
}

struct RemoteRevaluatedGenderItem: Decodable {
    let MALE: String?
    let FEMALE: String?
}

struct RemoteRevaluatedAgeItem: Decodable {
    let TEENS: String?
    let TWENTIES: String?
    let THIRTIES: String?
    let FORTIES: String?
    let FIFTIES_PLUS: String?
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
