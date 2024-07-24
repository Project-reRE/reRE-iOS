//
//  SplashViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

final class SplashViewModel: BaseViewModel {
    private let loginType = CurrentValueSubject<SNSLoginType?, Never>(nil)
    private let shouldSNSLogin = PassthroughSubject<LoginRequestModel, Never>()
    private let loginCompletion = PassthroughSubject<Void, Never>()
    
    private let usecase: SplashUsecaseProtocol
    
    init(usecase: SplashUsecaseProtocol) {
        self.usecase = usecase
        super.init(usecase: usecase)
        
        bind()
    }
    
    private func bind() {
        shouldSNSLogin
            .flatMap(usecase.snsLogin(withModel:))
            .sink { [weak self] _ in
                self?.loginCompletion.send(())
            }.store(in: &cancelBag)
    }
    
    func getLoginType() {
        loginType.send(usecase.getLoginType())
    }
    
    func getLoginTypePublisher() -> AnyPublisher<SNSLoginType?, Never> {
        return loginType.eraseToAnyPublisher()
    }
    
    func snsLogin(withToken accessToken: String, loginType: SNSLoginType) {
        shouldSNSLogin.send(.init(accessToken: accessToken, loginType: loginType))
    }
    
    func getLoginCompletionPublisher() -> AnyPublisher<Void, Never> {
        return loginCompletion.eraseToAnyPublisher()
    }
}
