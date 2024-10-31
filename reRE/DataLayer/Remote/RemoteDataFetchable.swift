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
    func getMyProfile() -> AnyPublisher<Result<UserEntity, Error>, Never>
    func updateUserInfo(withId id: String, requestModel: UpdateUserInfoRequestModel) -> AnyPublisher<Result<UserEntity, Error>, Never>
    func searchMovieList(with model: SearchMovieListRequestModel) -> AnyPublisher<Result<SearchMovieListEntity, Error>, Never>
    func getMyHistory(with model: MyHistoryRequestModel) -> AnyPublisher<Result<MyHistoryEntity, Error>, Never>
    func checkAlreadyRevaluated(withId movieId: String) -> AnyPublisher<Result<MyHistoryEntityData, Error>, Never>
    func getMovieDetail(withId movieId: String) -> AnyPublisher<Result<MovieDetailEntity, Error>, Never>
    func getOtherRevaluations(with model: OtherRevaluationsRequestModel) -> AnyPublisher<Result<OtherRevaluationsEntity, Error>, Never>
    func updateRevaluationLikes(withId revaluationId: String, isLiked: Bool) -> AnyPublisher<Result<String, Error>, Never>
    func revaluate(with reqestModel: RevaluateRequestModel) -> AnyPublisher<Result<Void, Error>, Never>
    func updateRevaluation(withId revaluationId: String, updatedModel: RevaluateRequestModel) -> AnyPublisher<Result<MyHistoryEntityData, Error>, Never>
    func deleteRevaluation(withId revaluationId: String) -> AnyPublisher<Result<Void, Error>, Never>
    
    func logout()
    func deleteAccount() -> AnyPublisher<Result<Void, Error>, Never>
}
