//
//  RankViewModel.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import Foundation
import Combine

final class RankViewModel: BaseViewModel {
    private var timer: Timer?
    private let timerSubject = PassthroughSubject<Void, Never>()
    
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
                var shouldDisplayBannerList = bannerList
                
                guard shouldDisplayBannerList.count > 1 else {
                    self?.bannerList.send(shouldDisplayBannerList)
                    return
                }
                
                guard let firstBanner = shouldDisplayBannerList.first,
                      let lastBanner = shouldDisplayBannerList.last else {
                    self?.bannerList.send(shouldDisplayBannerList)
                    return
                }
                
                shouldDisplayBannerList.insert(lastBanner, at: 0)
                shouldDisplayBannerList.append(firstBanner)
                
                self?.bannerList.send(shouldDisplayBannerList)
            }.store(in: &cancelBag)
    }
    
    func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.timerSubject.send(())
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var timerPublisher: AnyPublisher<Void, Never> {
        return timerSubject.eraseToAnyPublisher()
    }
    
    func getMovieSets() {
        shouldGetMovieSets.send(())
    }
    
    var movieSetsPublisher: AnyPublisher<[MovieSetsResponseModel], Never> {
        return movieSets.eraseToAnyPublisher()
    }
    
    var movieSetsValue: [MovieSetsResponseModel] {
        return movieSets.value
    }
    
    var isAllRevaluationEmpty: Bool {
        return movieSetsValue.allSatisfy({ $0.data.isEmpty }) || movieSetsValue.isEmpty
    }
    
    func getBannerList() {
        shouldGetBannerList.send(())
    }
    
    var bannerListPublisher: AnyPublisher<[BannerResponseModel], Never> {
        return bannerList.eraseToAnyPublisher()
    }
    
    var bannerListValue: [BannerResponseModel] {
        return bannerList.value
    }
}
