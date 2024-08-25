//
//  SplashViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit
import Combine
import KakaoSDKUser
import KakaoSDKAuth

final class SplashViewController: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    var coordinator: MainBaseCoordinator?
    
    private let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        bind()
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                LogDebug(error)
                
                CommonUtil.showAlertView(withType: .default,
                                         buttonType: .oneButton,
                                         title: error.localizedDescription,
                                         description: error.localizedDescription,
                                         submitCompletion: nil,
                                         cancelCompletion: nil)
            }.store(in: &cancelBag)
        
        viewModel.getLoginTypePublisher()
            .droppedSink { [weak self] loginType in
                if let loginType = loginType {
                    switch loginType {
                    case .kakao:
                        guard AuthApi.hasToken() else {
                            self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.rank), userData: nil)
                            return
                        }
                        
                        AuthApi.shared.refreshToken { [weak self] oAuthToken, error in
                            guard let token = oAuthToken?.accessToken, error == nil else {
                                LogDebug(error)
                                return
                            }
                            
                            print("oAuthToken: \(oAuthToken)")
                            self?.viewModel.snsLogin(withToken: token, loginType: .kakao)
                        }
                    case .apple:
                        self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.rank), userData: nil)
                    }
                } else {
                    self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.rank), userData: nil)
                }
            }.store(in: &cancelBag)
        
        viewModel.getLoginCompletionPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.rank), userData: nil)
            }.store(in: &cancelBag)
        
        viewModel.getLoginType()
    }
}
