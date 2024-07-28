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
    static let inquiryEmail = "rerevaluation@gmail.com"
    
}
//    공지사항: https://revaluation.notion.site/b458446df3b943749fb5b603f7155448?pvs=4
//    FAQ: https://revaluation.notion.site/cafff7657cd44b4991c7ce27cf39b384?pvs=4
//    복사할 메일: rerevaluation@gmail.com
//serviceAgreementButton.showTermsButton.didTapped { [weak self] in
//    self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.web),
//                              userData: ["urlString": "https://revaluation.notion.site/61bff9fc064047dbaeec12e2c792b526?pvs=74"])
//}
//
//privacyPolicyAgreementButton.showTermsButton.didTapped { [weak self] in
//    self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.web),
//                              userData: ["urlString": "https://revaluation.notion.site/3e61d87145254fc6b8cf02b7853304d7?pvs=74"])
//}
//서비스 이용약관:  https://revaluation.notion.site/61bff9fc064047dbaeec12e2c792b526?pvs=74
//개인정보 처리방침: https://revaluation.notion.site/3e61d87145254fc6b8cf02b7853304d7?pvs=74
