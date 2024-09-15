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
        dateComponents.month = 9
        dateComponents.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let userCalendar = Calendar(identifier: .gregorian)
        return userCalendar.date(from: dateComponents) ?? Date()
    }
    
    static let privacyPolicyUrlString = "https://revaluation.notion.site/3e61d87145254fc6b8cf02b7853304d7?pvs=74"
    static let serviceAgreementUrlString = "https://revaluation.notion.site/61bff9fc064047dbaeec12e2c792b526?pvs=74"
    static let noticeUrlString = "https://revaluation.notion.site/b458446df3b943749fb5b603f7155448?pvs=4"
    static let faqUrlString = "https://revaluation.notion.site/cafff7657cd44b4991c7ce27cf39b384?pvs=4"
    static let termsPolicyUrlString = "https://revaluation.notion.site/72ff79808476490aa5feb170caa59652"
    static let openAPIUrlString = "rerevaluation@gmail.com"
    static let inquiryEmail = "rerevaluation@gmail.com"
    
#if DEBUG
    static let googleClientId: String = "56958772101-f752a73km04gl11b9c661e5t0orc8lco.apps.googleusercontent.com"
    static let kakaoAppKey: String = "cd6a4d45774e3c2ce7409abcaaf1b0f8"
#else
    static let googleClientId: String = "56958772101-f752a73km04gl11b9c661e5t0orc8lco.apps.googleusercontent.com"
    static let kakaoAppKey: String = "cd6a4d45774e3c2ce7409abcaaf1b0f8"
#endif
    
}
