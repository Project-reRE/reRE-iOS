//
//  RemoteDataFetchable.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import Foundation
import Combine

protocol RemoteDataFetchable: AnyObject {
    func getBannerList() -> AnyPublisher<Result<[BannerEntity], Error>, Never>
    func getMovieSets() -> AnyPublisher<Result<[MovieSetsEntity], Error>, Never>
    func snsLogin(withToken accessToken: String, loginType: SNSLoginType) -> AnyPublisher<Result<String, Error>, Never>
    func signUp(withParams param: SignUpRequestModel) -> AnyPublisher<Result<String, Error>, Never>
}
