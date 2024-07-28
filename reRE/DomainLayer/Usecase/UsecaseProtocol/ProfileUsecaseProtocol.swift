//
//  ProfileUsecaseProtocol.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

protocol ProfileUsecaseProtocol: BaseUsecaseProtocol {
    func getMyProfile() -> AnyPublisher<MyProfileResponseModel, Never>
}