//
//  ProfileRepositoryProtocol.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

protocol ProfileRepositoryProtocol: AnyObject {
    func getMyProfile() -> AnyPublisher<Result<UserEntity, Error>, Never>
    func updateUserInfo(withId id: String, requestModel: UpdateUserInfoRequestModel) -> AnyPublisher<Result<UserEntity, Error>, Never>
    func getLoginType() -> SNSLoginType?
    func logout()
    func deleteAccount() -> AnyPublisher<Result<Void, Error>, Never>
}
