//
//  LoginViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/8/24.
//

import Foundation
import Combine

struct LoginRequestModel {
    let accessToken: String
    let loginType: SNSLoginType
}

final class LoginViewModel: BaseViewModel {
    private let isSatisfiedCondition = PassthroughSubject<Bool, Never>()
    
    private let shouldSNSLogin = CurrentValueSubject<LoginRequestModel, Never>(.init(accessToken: "", loginType: .kakao))
    private let shouldSignUp = PassthroughSubject<SignUpRequestModel, Never>()
    private let userBirth = CurrentValueSubject<String, Never>("")
    private let userGender = CurrentValueSubject<Bool?, Never>(nil)
    private let userAgreement = CurrentValueSubject<Bool, Never>(false)
    
    private let loginCompletion = PassthroughSubject<Void, Never>()
    
    private(set) var currentSNSMethod: SNSLoginType = .kakao
    
    private let usecase: LoginUsecaseProtocol
    
    init(usecase: LoginUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        shouldSNSLogin
            .dropFirst()
            .flatMap(usecase.snsLogin(withModel:))
            .sink { [weak self] _ in
                self?.loginCompletion.send(())
            }.store(in: &cancelBag)
        
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
            .sink { [weak self] userId in
                guard let self = self else { return }
                self.shouldSNSLogin.send(self.shouldSNSLogin.value)
            }.store(in: &cancelBag)
    }
    
    func snsLogin(withToken accessToken: String, loginType: SNSLoginType) {
        currentSNSMethod = loginType
        shouldSNSLogin.send(.init(accessToken: accessToken, loginType: loginType))
    }
    
    func setUserBirth(withYear year: String) {
        userBirth.send(year)
    }
    
    func canSignUpAge() -> Bool {
        guard let birthday = userBirth.value.toDate(with: "yyyy") else { return false }
        guard let age = Calendar.current.dateComponents([.year], from: birthday, to: Date()).year else { return false }
        return age >= 14
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
        
        shouldSignUp.send(SignUpRequestModel(provider: shouldSNSLogin.value.loginType.provider,
                                             gender: gender,
                                             birthDate: userBirth.value))
    }
    
    func getLoginCompletionPublisher() -> AnyPublisher<Void, Never> {
        return loginCompletion.eraseToAnyPublisher()
    }
}
