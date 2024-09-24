//
//  RevaluateRequestModel.swift
//  reRE
//
//  Created by 강치훈 on 9/7/24.
//

import Foundation

struct RevaluateRequestModel: Encodable {
    var movieId: String?
    var numStars: Double
    var specialPoint: String
    var pastValuation: String
    var presentValuation: String
    var comment: String
    
    init(movieId: String?,
         numStars: Double,
         specialPoint: String,
         pastValuation: String,
         presentValuation: String,
         comment: String) {
        self.movieId = movieId
        self.numStars = numStars
        self.specialPoint = specialPoint
        self.pastValuation = pastValuation
        self.presentValuation = presentValuation
        self.comment = comment
    }
    
    init() {
        movieId = nil
        numStars = 0
        specialPoint = ""
        pastValuation = ""
        presentValuation = ""
        comment = ""
    }
    
    enum RevaluateCategory {
        case numStars
        case specialPoint
        case pastValuation
        case presentValuation
        case comment
    }
    
    func missingCategory() -> RevaluateCategory? {
        if numStars == 0 {
            return .numStars
        } else if specialPoint.isEmpty {
            return .specialPoint
        } else if pastValuation.isEmpty {
            return .pastValuation
        } else if presentValuation.isEmpty {
            return .presentValuation
        } else if comment.isEmpty {
            return .comment
        }
        
        return nil
    }
}
