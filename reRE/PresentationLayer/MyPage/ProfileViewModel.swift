//
//  ProfileViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

final class ProfileViewModel: BaseViewModel {
    private let myProfile = CurrentValueSubject<UserEntity, Never>(.init())
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
    
    func getMyProfilePublisher() -> AnyPublisher<UserEntity, Never> {
        return myProfile.eraseToAnyPublisher()
    }
    
    func getMyProfileValue() -> UserEntity {
        return myProfile.value
    }
    
    func updateNickname(with nickname: String) {
        usecase.updateUserInfo(withId: myProfile.value.id,
                               requestModel: .init(profileUrl: myProfile.value.profileUrl,
                                                   nickName: nickname))
        .sink { [weak self] userEntity in
            self?.myProfile.value.nickName = nickname
        }.store(in: &cancelBag)
    }
    
    func logout() {
        usecase.logout()
    }
}
