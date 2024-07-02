//
//  RankViewModel.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import Foundation
import Combine

final class RankViewModel: BaseViewModel {
    private let shouldGetBannerList = PassthroughSubject<Void, Never>()
    private let bannerList = CurrentValueSubject<[BannerResponseModel], Never>([])
    
    private let usecase: RankUsecaseProtocol
    
    init(usecase: RankUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        shouldGetBannerList
            .flatMap(usecase.getBannerList)
            .sink { [weak self] bannerList in
                self?.bannerList.send(bannerList.filter { $0.display })
            }.store(in: &cancelBag)
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
