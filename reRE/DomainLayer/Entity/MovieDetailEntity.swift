//
//  MovieDetailEntity.swift
//  reRE
//
//  Created by 강치훈 on 8/25/24.
//

import Foundation

struct MovieDetailEntity {
    let id: String
    let data: SearchMovieListDataEntity
    let statistics: [MovieStatisticsEntity]
    
    init(id: String, data: SearchMovieListDataEntity, statistics: [MovieStatisticsEntity]) {
        self.id = id
        self.data = data
        self.statistics = statistics
    }
    
    init() {
        id = ""
        data = .init()
        statistics = []
    }
}

struct MovieStatisticsEntity {
    let id: String
    let numRecentStars: [MovieRecentRatingsEntity]
    let numStars: Double
    let numStarsParticipants: Int
    let numSpecialPoint: MovieSpecialPointEntity
    let numPastValuation: MovieFeelingsEntity
    let numPresentValuation: MovieFeelingsEntity
    let numGender: RevaluatedGenderEntity
    let numAge: RevaluatedAgeEntity
    let currentDate: String
}

struct MovieRecentRatingsEntity {
    let currentDate: String
    let numStars: Double
    
    init(currentDate: String, numStars: Double) {
        self.currentDate = currentDate
        self.numStars = numStars
    }
    
    init() {
        currentDate = ""
        numStars = 0
    }
}

struct MovieSpecialPointEntity {
    let PLANNING_INTENT: Int
    let DIRECTORS_DIRECTION: Int
    let ACTING_SKILLS: Int
    let SCENARIO: Int
    let OST: Int
    let SOCIAL_ISSUES: Int
    let VISUAL_ELEMENT: Int
    let SOUND_ELEMENT: Int
}

struct MovieFeelingsEntity {
    let POSITIVE: Int
    let NEGATIVE: Int
    let NOT_SURE: Int
}

struct RevaluatedGenderEntity {
    let MALE: Int
    let FEMALE: Int
}

struct RevaluatedAgeEntity {
    let TEENS: Int
    let TWENTIES: Int
    let THIRTIES: Int
    let FORTIES: Int
    let FIFTIES_PLUS: Int
}
