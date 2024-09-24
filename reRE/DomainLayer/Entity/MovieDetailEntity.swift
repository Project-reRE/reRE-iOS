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
    let numSpecialPointTopThree: [MovieMostSpecialPointEntity]
    let numPastValuationPercent: [MovieStatisticsPercentageEntity]
    let numPresentValuationPercent: [MovieStatisticsPercentageEntity]
    let numGenderPercent: [MovieStatisticsPercentageEntity]
    let numAgePercent: [MovieStatisticsPercentageEntity]
    
    init(id: String,
         numRecentStars: [MovieRecentRatingsEntity],
         numStars: Double,
         numStarsParticipants: Int,
         numSpecialPoint: MovieSpecialPointEntity,
         numPastValuation: MovieFeelingsEntity,
         numPresentValuation: MovieFeelingsEntity,
         numGender: RevaluatedGenderEntity,
         numAge: RevaluatedAgeEntity,
         currentDate: String,
         numSpecialPointTopThree: [MovieMostSpecialPointEntity],
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
        numStars = 0
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
    let PLANNING_INTENT: Int
    let DIRECTORS_DIRECTION: Int
    let ACTING_SKILLS: Int
    let SCENARIO: Int
    let OST: Int
    let SOCIAL_ISSUES: Int
    let VISUAL_ELEMENT: Int
    let SOUND_ELEMENT: Int
    
    init(PLANNING_INTENT: Int,
         DIRECTORS_DIRECTION: Int,
         ACTING_SKILLS: Int,
         SCENARIO: Int,
         OST: Int,
         SOCIAL_ISSUES: Int,
         VISUAL_ELEMENT: Int,
         SOUND_ELEMENT: Int) {
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
        PLANNING_INTENT = 0
        DIRECTORS_DIRECTION = 0
        ACTING_SKILLS = 0
        SCENARIO = 0
        OST = 0
        SOCIAL_ISSUES = 0
        VISUAL_ELEMENT = 0
        SOUND_ELEMENT = 0
    }
}

struct MovieFeelingsEntity {
    let POSITIVE: Int
    let NEGATIVE: Int
    let NOT_SURE: Int
    
    init(POSITIVE: Int, NEGATIVE: Int, NOT_SURE: Int) {
        self.POSITIVE = POSITIVE
        self.NEGATIVE = NEGATIVE
        self.NOT_SURE = NOT_SURE
    }
    
    init() {
        POSITIVE = 0
        NEGATIVE = 0
        NOT_SURE = 0
    }
}

struct RevaluatedGenderEntity {
    let MALE: Int
    let FEMALE: Int
    
    init(MALE: Int, FEMALE: Int) {
        self.MALE = MALE
        self.FEMALE = FEMALE
    }
    
    init() {
        MALE = 0
        FEMALE = 0
    }
}

struct RevaluatedAgeEntity {
    let TEENS: Int
    let TWENTIES: Int
    let THIRTIES: Int
    let FORTIES: Int
    let FIFTIES_PLUS: Int
    
    init(TEENS: Int, TWENTIES: Int, THIRTIES: Int, FORTIES: Int, FIFTIES_PLUS: Int) {
        self.TEENS = TEENS
        self.TWENTIES = TWENTIES
        self.THIRTIES = THIRTIES
        self.FORTIES = FORTIES
        self.FIFTIES_PLUS = FIFTIES_PLUS
    }
    
    init() {
        TEENS = 0
        TWENTIES = 0
        THIRTIES = 0
        FORTIES = 0
        FIFTIES_PLUS = 0
    }
}

struct MovieMostSpecialPointEntity {
    let rank: Int
    let type: String
    let value: Int
    
    init(rank: Int, type: String, value: Int) {
        self.rank = rank
        self.type = type
        self.value = value
    }
    
    init() {
        rank = 0
        type = ""
        value = 0
    }
}

struct MovieStatisticsPercentageEntity {
    let rank: Int
    let type: String
    let value: String
    
    init(rank: Int, type: String, value: String) {
        self.rank = rank
        self.type = type
        self.value = value
    }
    
    init() {
        rank = 0
        type = ""
        value = ""
    }
}
