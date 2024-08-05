//
//  ProfileViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

final class ProfileViewModel: BaseViewModel {
    private let myProfile = CurrentValueSubject<MyProfileResponseModel, Never>(.init())
    private let shouldGetMyProfile = PassthroughSubject<Void, Never>()
    private let loginCompletion = PassthroughSubject<Void, Never>()
    
    private let usecase: ProfileUsecaseProtocol
    
    init(usecase: ProfileUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        shouldGetMyProfile
            .flatMap(usecase.getMyProfile)
            .sink { [weak self] myProfileResponse in
                self?.myProfile.send(myProfileResponse)
            }.store(in: &cancelBag)
    }
    
    func getMyProfile() {
        shouldGetMyProfile.send(())
    }
    
    func getMyProfilePublisher() -> AnyPublisher<MyProfileResponseModel, Never> {
        return myProfile.eraseToAnyPublisher()
    }
    
    func getMyProfileValue() -> MyProfileResponseModel {
        return myProfile.value
    }
    
    func logout() {
        usecase.logout()
    }
}
