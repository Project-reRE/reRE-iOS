//
//  StaticValues.swift
//  reRE
//
//  Created by 강치훈 on 7/23/24.
//

import Foundation
import Combine

struct StaticValues {
    static var isLoggedIn = CurrentValueSubject<Bool, Never>(false)
    
    static var openedMonth: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 11
        dateComponents.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let userCalendar = Calendar(identifier: .gregorian)
        return userCalendar.date(from: dateComponents) ?? Date()
    }
    
    static let privacyPolicyUrlString = "https://reevaluation.notion.site/3e61d87145254fc6b8cf02b7853304d7"
    static let serviceAgreementUrlString = "https://reevaluation.notion.site/61bff9fc064047dbaeec12e2c792b526"
    static let noticeUrlString = "https://reevaluation.notion.site/b458446df3b943749fb5b603f7155448"
    static let faqUrlString = "https://reevaluation.notion.site/cafff7657cd44b4991c7ce27cf39b384"
    static let termsPolicyUrlString = "https://reevaluation.notion.site/72ff79808476490aa5feb170caa59652?pvs=74"
    static let openAPIUrlString = "https://reevaluation.notion.site/API-e55e49e9c48140e8be8c8a4f6ce13f2f?pvs=74"
    static let inquiryEmail = "rerevaluation@gmail.com"
    
#if DEBUG
    static let googleClientId: String = "56958772101-mvd7e443a88vd59pu8k07eeloenttnu0.apps.googleusercontent.com"
    static let kakaoAppKey: String = "cd6a4d45774e3c2ce7409abcaaf1b0f8"
#else
    static let googleClientId: String = "56958772101-mvd7e443a88vd59pu8k07eeloenttnu0.apps.googleusercontent.com"
    static let kakaoAppKey: String = "cd6a4d45774e3c2ce7409abcaaf1b0f8"
#endif
    
}
