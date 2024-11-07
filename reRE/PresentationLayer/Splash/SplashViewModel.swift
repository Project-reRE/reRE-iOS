//
//  SplashViewModel.swift
//  reRE
//
//  Created by 강치훈 on 7/24/24.
//

import Foundation
import Combine

enum VersionAction {
    case forceUpdate
    case optionalUpdate
    case normal
}

final class SplashViewModel: BaseViewModel {
    private let versionAction = PassthroughSubject<VersionAction, Never>()
    var versionActionPublisher: AnyPublisher<VersionAction, Never> {
        return versionAction.eraseToAnyPublisher()
    }
    
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
    
    func versionCheck() {
        usecase.versionCheck()
            .sink { [weak self] versionEntity in
                if CommonUtil.appVersion.compare(versionEntity.minimumVersion, options: .numeric) == .orderedAscending {
                    self?.versionAction.send(.forceUpdate)
                } else if CommonUtil.appVersion.compare(versionEntity.stableVersion, options: .numeric) == .orderedAscending {
                    self?.versionAction.send(.optionalUpdate)
                } else {
                    self?.versionAction.send(.normal)
                }
            }.store(in: &cancelBag)
    }
    
    func getLoginType() {
        let loginType: SNSLoginType? = usecase.getLoginType()
        self.loginType.send(loginType)
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
