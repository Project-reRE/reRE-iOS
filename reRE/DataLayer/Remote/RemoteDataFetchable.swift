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
    func snsLogin(withModel model: LoginRequestModel) -> AnyPublisher<Result<String, Error>, Never>
    func signUp(withParams param: SignUpRequestModel) -> AnyPublisher<Result<String, Error>, Never>
    func getMyProfile() -> AnyPublisher<Result<MyProfileEntity, Error>, Never>
    func searchMovieList(with model: SearchMovieListRequestModel) -> AnyPublisher<Result<SearchMovieListEntity, Error>, Never>
    func getMyHistory(with model: MyHistoryRequestModel) -> AnyPublisher<Result<MyHistoryEntity, Error>, Never>
    func logout()
    func deleteAccount() -> AnyPublisher<Result<String, Error>, Never>
}
