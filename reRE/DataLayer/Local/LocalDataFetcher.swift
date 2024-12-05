//
//  LocalDataFetcher.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import Foundation

final class LocalDataFetcher: LocalDataFetchable {
    func getLoginType() -> String? {
        return UserDefaultsManager.shared.getLoginType()
    }
    
    func setLoginType(loginType: String) {
        UserDefaultsManager.shared.setLoginType(loginType: loginType)
    }
}
