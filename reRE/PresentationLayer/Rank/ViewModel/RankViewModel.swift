//
//  RankViewModel.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import Foundation
import Combine

final class RankViewModel: BaseViewModel {
    private let shouldGetMovieSets = PassthroughSubject<Void, Never>()
    private let movieSets = CurrentValueSubject<[MovieSetsResponseModel], Never>([])
    
    private let shouldGetBannerList = PassthroughSubject<Void, Never>()
    private let bannerList = CurrentValueSubject<[BannerResponseModel], Never>([])
    
    private let usecase: RankUsecaseProtocol
    
    init(usecase: RankUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        shouldGetMovieSets
            .flatMap(usecase.getMovieSets)
            .sink { [weak self] movieSets in
                self?.movieSets.send(movieSets)
            }.store(in: &cancelBag)
        
        shouldGetBannerList
            .flatMap(usecase.getBannerList)
            .sink { [weak self] bannerList in
                self?.bannerList.send(bannerList.filter { $0.display })
            }.store(in: &cancelBag)
    }
    
    func getMovieSets() {
        shouldGetMovieSets.send(())
    }
    
    func getMovieSetsPublisher() -> AnyPublisher<[MovieSetsResponseModel], Never> {
        return movieSets.eraseToAnyPublisher()
    }
    
    func getMovieSetsValue() -> [MovieSetsResponseModel] {
        return movieSets.value
    }
    
    func getBannerList() {
        shouldGetBannerList.send(())
    }
    
    func getBannerListPublisher() -> AnyPublisher<[BannerResponseModel], Never> {
        return bannerList.eraseToAnyPublisher()
    }
    
    func getBannerListValue() -> [BannerResponseModel] {
        return bannerList.value
    }
}
