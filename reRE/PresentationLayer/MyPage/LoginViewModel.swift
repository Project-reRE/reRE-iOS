//
//  LoginViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/8/24.
//

import Foundation
import Combine

final class LoginViewModel: BaseViewModel {
    private let shouldSNSLogin = PassthroughSubject<(String, SNSLoginType), Never>()
    
    private let jwt = CurrentValueSubject<String, Never>("")
    
    private let usecase: LoginUsecaseProtocol
    
    init(usecase: LoginUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        shouldSNSLogin
            .flatMap(usecase.snsLogin(withToken:loginType:))
            .sink { [weak self] jwt in
                self?.jwt.send(jwt)
            }.store(in: &cancelBag)
    }
    
    func snsLogin(withToken accessToken: String, loginType: SNSLoginType) {
        shouldSNSLogin.send((accessToken, loginType))
    }
    
    func getjwtPublisher() -> AnyPublisher<String, Never> {
        return jwt.eraseToAnyPublisher()
    }
    
    func getjwtValue() -> String {
        return jwt.value
    }
}
