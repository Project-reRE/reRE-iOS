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
}
