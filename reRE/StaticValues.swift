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
    
    static let privacyPolicyUrlString = "https://revaluation.notion.site/3e61d87145254fc6b8cf02b7853304d7?pvs=74"
    static let serviceAgreementUrlString = "https://revaluation.notion.site/61bff9fc064047dbaeec12e2c792b526?pvs=74"
    static let noticeUrlString = "https://revaluation.notion.site/b458446df3b943749fb5b603f7155448?pvs=4"
    static let faqUrlString = "https://revaluation.notion.site/cafff7657cd44b4991c7ce27cf39b384?pvs=4"
    static let termsPolicyUrlString = "https://revaluation.notion.site/72ff79808476490aa5feb170caa59652"
    static let inquiryEmail = "rerevaluation@gmail.com"
}
