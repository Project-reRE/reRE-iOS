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
}
