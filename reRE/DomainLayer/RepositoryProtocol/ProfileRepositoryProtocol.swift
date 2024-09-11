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
    func logout()
    func deleteAccount() -> AnyPublisher<Result<String, Error>, Never>
}
