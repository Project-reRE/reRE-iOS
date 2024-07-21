//
//  SignUpViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/10/24.
//

import Foundation
import Combine
import KakaoSDKUser

final class SignUpViewModel: BaseViewModel {
    private let isSatisfiedCondition = PassthroughSubject<Bool, Never>()
    
    private let shouldSignUp = PassthroughSubject<SignUpRequestModel, Never>()
    private let userBirth = CurrentValueSubject<String, Never>("")
    private let userGender = CurrentValueSubject<Bool?, Never>(nil)
    private let userAgreement = CurrentValueSubject<Bool, Never>(false)
    
    private let usecase: LoginUsecaseProtocol
    
    init(usecase: LoginUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        let userBirthPublisher = userBirth.eraseToAnyPublisher().dropFirst()
        let userGenderPublisher = userGender.eraseToAnyPublisher().dropFirst()
        let userAgreementPublisher = userAgreement.eraseToAnyPublisher().dropFirst()
        
        userBirthPublisher
            .combineLatest(userGenderPublisher, userAgreementPublisher)
            .sink { [weak self] birth, gender, agreement in
                guard let selectedGender = gender else {
                    self?.isSatisfiedCondition.send(false)
                    return
                }
                
                let isValidBirth: Bool = birth.count == 4
                self?.isSatisfiedCondition.send(isValidBirth && selectedGender && agreement)
            }.store(in: &cancelBag)
        
        shouldSignUp
            .flatMap(usecase.signUp(withParams:))
            .sink { userId in
                print("userId: \(userId)")
            }.store(in: &cancelBag)
    }
    
    func setUserBirth(withYear year: String) {
        userBirth.send(year)
    }
    
    func setUserGender(isMale: Bool) {
        userGender.send(isMale)
    }
    
    func setUserAgreement(isAllAgree: Bool) {
        userAgreement.send(isAllAgree)
    }
    
    func getSatisfiedConditionPublisher() -> AnyPublisher<Bool, Never> {
        return isSatisfiedCondition.eraseToAnyPublisher()
    }
    
    func signUp() {
        guard let gender = userGender.value else { return }
        
        UserApi.shared.me { [weak self] user, error in
            guard let self = self else { return }
            guard error == nil else {
                LogDebug(error)
                return
            }
            
            self.shouldSignUp.send(SignUpRequestModel(provider: "kakao",
                                                      profileUrl: user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString,
                                                      description: "",
                                                      gender: gender,
                                                      birthDate: self.userBirth.value))
        }
    }
}
