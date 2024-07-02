//
//  RankUsecaseProtocol.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation
import Combine

protocol RankUsecaseProtocol: BaseUsecaseProtocol {
    func getBannerList() -> AnyPublisher<[BannerResponseModel], Never>
    func getMovieSets() -> AnyPublisher<[MovieSetsResponseModel], Never>
}
