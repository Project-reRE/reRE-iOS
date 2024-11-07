//
//  SplashUsecaseProtocol.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

protocol SplashUsecaseProtocol: BaseUsecaseProtocol {
    func versionCheck() -> AnyPublisher<VersionEntity, Never>
    func getLoginType() -> SNSLoginType?
    func snsLogin(withModel model: LoginRequestModel) -> AnyPublisher<String, Never>
}
