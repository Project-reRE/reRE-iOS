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
    let numStars: String
    let numStarsParticipants: Int
    let numSpecialPoint: MovieSpecialPointEntity
    let numPastValuation: MovieFeelingsEntity
    let numPresentValuation: MovieFeelingsEntity
    let numGender: RevaluatedGenderEntity
    let numAge: RevaluatedAgeEntity
    let currentDate: String
    let numSpecialPointTopThree: [MovieStatisticsPercentageEntity]
    let numPastValuationPercent: [MovieStatisticsPercentageEntity]
    let numPresentValuationPercent: [MovieStatisticsPercentageEntity]
    let numGenderPercent: [MovieStatisticsPercentageEntity]
    let numAgePercent: [MovieStatisticsPercentageEntity]
    
    init(id: String,
         numRecentStars: [MovieRecentRatingsEntity],
         numStars: String,
         numStarsParticipants: Int,
         numSpecialPoint: MovieSpecialPointEntity,
         numPastValuation: MovieFeelingsEntity,
         numPresentValuation: MovieFeelingsEntity,
         numGender: RevaluatedGenderEntity,
         numAge: RevaluatedAgeEntity,
         currentDate: String,
         numSpecialPointTopThree: [MovieStatisticsPercentageEntity],
         numPastValuationPercent: [MovieStatisticsPercentageEntity],
         numPresentValuationPercent: [MovieStatisticsPercentageEntity],
         numGenderPercent: [MovieStatisticsPercentageEntity],
         numAgePercent: [MovieStatisticsPercentageEntity]) {
        self.id = id
        self.numRecentStars = numRecentStars
        self.numStars = numStars
        self.numStarsParticipants = numStarsParticipants
        self.numSpecialPoint = numSpecialPoint
        self.numPastValuation = numPastValuation
        self.numPresentValuation = numPresentValuation
        self.numGender = numGender
        self.numAge = numAge
        self.currentDate = currentDate
        self.numSpecialPointTopThree = numSpecialPointTopThree
        self.numPastValuationPercent = numPastValuationPercent
        self.numPresentValuationPercent = numPresentValuationPercent
        self.numGenderPercent = numGenderPercent
        self.numAgePercent = numAgePercent
    }
    
    init() {
        id = ""
        numRecentStars = []
        numStars = ""
        numStarsParticipants = 0
        numSpecialPoint = .init()
        numPastValuation = .init()
        numPresentValuation = .init()
        numGender = .init()
        numAge = .init()
        currentDate = ""
        numSpecialPointTopThree = []
        numPastValuationPercent = []
        numPresentValuationPercent = []
        numGenderPercent = []
        numAgePercent = []
    }
}

struct MovieRecentRatingsEntity {
    let currentDate: String
    let numStars: String
    
    init(currentDate: String, numStars: String) {
        self.currentDate = currentDate
        self.numStars = numStars
    }
    
    init() {
        currentDate = ""
        numStars = ""
    }
}

struct MovieSpecialPointEntity {
    let PLANNING_INTENT: String
    let DIRECTORS_DIRECTION: String
    let ACTING_SKILLS: String
    let SCENARIO: String
    let OST: String
    let SOCIAL_ISSUES: String
    let VISUAL_ELEMENT: String
    let SOUND_ELEMENT: String
    
    init(PLANNING_INTENT: String,
         DIRECTORS_DIRECTION: String,
         ACTING_SKILLS: String,
         SCENARIO: String,
         OST: String,
         SOCIAL_ISSUES: String,
         VISUAL_ELEMENT: String,
         SOUND_ELEMENT: String) {
        self.PLANNING_INTENT = PLANNING_INTENT
        self.DIRECTORS_DIRECTION = DIRECTORS_DIRECTION
        self.ACTING_SKILLS = ACTING_SKILLS
        self.SCENARIO = SCENARIO
        self.OST = OST
        self.SOCIAL_ISSUES = SOCIAL_ISSUES
        self.VISUAL_ELEMENT = VISUAL_ELEMENT
        self.SOUND_ELEMENT = SOUND_ELEMENT
    }
    
    init() {
        PLANNING_INTENT = ""
        DIRECTORS_DIRECTION = ""
        ACTING_SKILLS = ""
        SCENARIO = ""
        OST = ""
        SOCIAL_ISSUES = ""
        VISUAL_ELEMENT = ""
        SOUND_ELEMENT = ""
    }
}

struct MovieFeelingsEntity {
    let POSITIVE: String
    let NEGATIVE: String
    let NOT_SURE: String
    
    init(POSITIVE: String, NEGATIVE: String, NOT_SURE: String) {
        self.POSITIVE = POSITIVE
        self.NEGATIVE = NEGATIVE
        self.NOT_SURE = NOT_SURE
    }
    
    init() {
        POSITIVE = ""
        NEGATIVE = ""
        NOT_SURE = ""
    }
}

struct RevaluatedGenderEntity {
    let MALE: String
    let FEMALE: String
    let UNKNOWN: String
    
    init(MALE: String, FEMALE: String, UNKNOWN: String) {
        self.MALE = MALE
        self.FEMALE = FEMALE
        self.UNKNOWN = UNKNOWN
    }
    
    init() {
        MALE = ""
        FEMALE = ""
        UNKNOWN = ""
    }
}

struct RevaluatedAgeEntity {
    let TEENS: String
    let TWENTIES: String
    let THIRTIES: String
    let FORTIES: String
    let FIFTIES_PLUS: String
    let UNKNOWN: String
    
    init(TEENS: String, TWENTIES: String, THIRTIES: String, FORTIES: String, FIFTIES_PLUS: String, UNKNOWN: String) {
        self.TEENS = TEENS
        self.TWENTIES = TWENTIES
        self.THIRTIES = THIRTIES
        self.FORTIES = FORTIES
        self.FIFTIES_PLUS = FIFTIES_PLUS
        self.UNKNOWN = UNKNOWN
    }
    
    init() {
        TEENS = ""
        TWENTIES = ""
        THIRTIES = ""
        FORTIES = ""
        FIFTIES_PLUS = ""
        UNKNOWN = ""
    }
}

struct MovieStatisticsPercentageEntity {
    let rank: String
    let type: String
    let value: String
    
    init(rank: String, type: String, value: String) {
        self.rank = rank
        self.type = type
        self.value = value
    }
    
    init() {
        rank = ""
        type = ""
        value = ""
    }
}
