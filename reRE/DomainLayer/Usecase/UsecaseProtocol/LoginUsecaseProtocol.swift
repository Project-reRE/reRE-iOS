//
//  LoginUsecaseProtocol.swift
//  reRE
//
//  Created by 강치훈 on 7/8/24.
//

import Foundation
import Combine

protocol LoginUsecaseProtocol: BaseUsecaseProtocol {
    func snsLogin(withToken accessToken: String, loginType: SNSLoginType) -> AnyPublisher<String, Never>
    func signUp(withParams param: SignUpRequestModel) -> AnyPublisher<String, Never>
}
