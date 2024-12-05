//
//  RankRepositoryProtocol.swift
//  reRE
//
//  Created by 강치훈 on 7/1/24.
//

import Foundation
import Combine

protocol RankRepositoryProtocol: AnyObject {
    func getBannerList() -> AnyPublisher<Result<[BannerEntity], Error>, Never>
    func getMovieSets() -> AnyPublisher<Result<[MovieSetsEntity], Error>, Never>
}
