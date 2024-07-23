//
//  UserDefaultsManager.swift
//  reRE
//
//  Created by 강치훈 on 7/23/24.
//

import Foundation

struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    private enum UserDefaultKey: String {
        case loginType
    }
    
    func getLoginType() -> String? {
        return defaults.value(forKey: UserDefaultKey.loginType.rawValue) as? String
    }
    
    func setLoginType(loginType: String) {
        defaults.setValue(loginType, forKey: UserDefaultKey.loginType.rawValue)
    }
}
