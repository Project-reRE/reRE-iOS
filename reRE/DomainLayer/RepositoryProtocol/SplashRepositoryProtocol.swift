//
//  SplashRepositoryProtocol.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

protocol SplashRepositoryProtocol: AnyObject {
    func versionCheck() -> AnyPublisher<Result<VersionEntity, Error>, Never>
    func getLoginType() -> SNSLoginType?
    func snsLogin(withModel model: LoginRequestModel) -> AnyPublisher<Result<String, Error>, Never>
}
