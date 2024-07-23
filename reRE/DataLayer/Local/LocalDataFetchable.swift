//
//  LocalDataFetchable.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import Foundation

protocol LocalDataFetchable: AnyObject {
    func getLoginType() -> String?
    func setLoginType(loginType: String)
}
