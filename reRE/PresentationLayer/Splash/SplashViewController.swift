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
import GoogleSignIn
import AuthenticationServices
import Then
import SnapKit

final class SplashViewController: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    var coordinator: MainBaseCoordinator?
    
    private lazy var splashBGImageView = UIImageView().then {
        $0.image = UIImage(named: "SplashImage")
        $0.contentMode = .scaleAspectFit
    }
    
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
        
        view.backgroundColor = .clear
        
        view.addSubview(splashBGImageView)
        splashBGImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bind()
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .mainSink { [weak self] error in
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
                                self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.rank), userData: nil)
                                return
                            }
                            
                            self?.viewModel.snsLogin(withToken: token, loginType: .kakao)
                        }
                    case .apple:
                        self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.rank), userData: nil)
                    case .google:
                        let clientID: String = StaticValues.googleClientId
                        let config = GIDConfiguration(clientID: clientID)
                        GIDSignIn.sharedInstance.configuration = config
                        
                        guard let token = GIDSignIn.sharedInstance.currentUser?.refreshToken.tokenString else {
                            self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.rank), userData: nil)
                            return
                        }
                        
                        self?.viewModel.snsLogin(withToken: token, loginType: .google)
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
