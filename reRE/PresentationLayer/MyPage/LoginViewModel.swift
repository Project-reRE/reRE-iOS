//
//  LoginViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/8/24.
//

import Foundation
import Combine

final class LoginViewModel: BaseViewModel {
    private let shouldSNSLogin = PassthroughSubject<String, Never>()
    
    private let jwt = CurrentValueSubject<String, Never>("")
    
    private let usecase: LoginUsecaseProtocol
    
    init(usecase: LoginUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        shouldSNSLogin
            .flatMap(usecase.snsLogin(withToken:))
            .sink { [weak self] jwt in
                self?.jwt.send(jwt)
            }.store(in: &cancelBag)
    }
    
    func snsLogin(withToken accessToken: String) {
        shouldSNSLogin.send(accessToken)
    }
    
    func getjwtPublisher() -> AnyPublisher<String, Never> {
        return jwt.eraseToAnyPublisher()
    }
    
    func getjwtValue() -> String {
        return jwt.value
    }
}
