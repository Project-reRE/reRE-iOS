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
    var email: String
    let loginType: SNSLoginType
}

enum GenderType: String {
    case male = "MALE"
    case female = "FEMALE"
    case unknown = "UNKNOWN"
}

final class LoginViewModel: BaseViewModel {
    private let isSatisfiedCondition = PassthroughSubject<Bool, Never>()
    
    private let shouldSNSLogin = CurrentValueSubject<LoginRequestModel, Never>(.init(accessToken: "", email: "", loginType: .kakao))
    private let shouldSignUp = PassthroughSubject<SignUpRequestModel, Never>()
    private let userBirth = CurrentValueSubject<String?, Never>(nil)
    private let userGender = CurrentValueSubject<GenderType?, Never>(nil)
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
                guard gender != nil else {
                    self?.isSatisfiedCondition.send(false)
                    return
                }
                
                let isValidBirth: Bool = birth == nil || birth?.count == 4
                self?.isSatisfiedCondition.send(isValidBirth && agreement)
            }.store(in: &cancelBag)
        
        shouldSignUp
            .flatMap(usecase.signUp(withParams:))
            .sink { [weak self] userId in
                guard let self = self else { return }
                self.shouldSNSLogin.send(self.shouldSNSLogin.value)
            }.store(in: &cancelBag)
    }
    
    func snsLogin(with model: LoginRequestModel) {
        currentSNSMethod = model.loginType
        
        var moderatedModel: LoginRequestModel = model
        
        if moderatedModel.email.isEmpty {
            moderatedModel.email = shouldSNSLogin.value.email
        }
        
        shouldSNSLogin.send(moderatedModel)
    }
    
    func setUserBirth(withYear year: String?) {
        userBirth.send(year)
    }
    
    func canSignUpAge() -> Bool {
        guard userBirth.value != nil else { return true }
        guard let birthday = userBirth.value?.toDate(with: "yyyy") else { return false }
        guard let age = Calendar.current.dateComponents([.year], from: birthday, to: Date()).year else { return false }
        return age >= 14
    }
    
    func setUserGender(to gender: GenderType) {
        userGender.send(gender)
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
                                             gender: gender.rawValue,
                                             birthDate: userBirth.value,
                                             email: shouldSNSLogin.value.email))
    }
    
    func getLoginCompletionPublisher() -> AnyPublisher<Void, Never> {
        return loginCompletion.eraseToAnyPublisher()
    }
}
