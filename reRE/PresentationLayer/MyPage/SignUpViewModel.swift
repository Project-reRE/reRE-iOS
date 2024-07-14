//
//  SignUpViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/10/24.
//

import Foundation
import Combine

final class SignUpViewModel: BaseViewModel {
    private let isSatisfiedCondition = PassthroughSubject<Bool, Never>()
    
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
}
