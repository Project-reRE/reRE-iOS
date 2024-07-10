//
//  LoginRepositoryProtocol.swift
//  reRE
//
//  Created by 강치훈 on 7/8/24.
//

import Foundation
import Combine

protocol LoginRepositoryProtocol: AnyObject {
    func snsLogin(withToken accessToken: String) -> AnyPublisher<Result<String, Error>, Never>
    func signUp(withParams param: SignUpRequestModel) -> AnyPublisher<Result<String, Error>, Never>
}
