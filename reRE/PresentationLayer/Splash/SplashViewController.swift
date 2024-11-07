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
                                         submitCompletion: { [weak self] in
                    self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.rank), userData: nil)
                }, cancelCompletion: nil)
            }.store(in: &cancelBag)
        
        viewModel.versionActionPublisher
            .mainSink { [weak self] versionAction in
                switch versionAction {
                case .forceUpdate:
                    CommonUtil.showAlertView(withType: .default,
                                             buttonType: .oneButton,
                                             title: "업데이트",
                                             description: "보다 원활한 이용을 위해\n업데이트를 진행해주세요.",
                                             submitCompletion: {
                        CommonUtil.goToAppStore()
                    }, cancelCompletion: nil)
                case .optionalUpdate:
                    CommonUtil.showAlertView(withType: .default,
                                             buttonType: .twoButton,
                                             title: "업데이트",
                                             description: "보다 원활한 이용을 위해\n업데이트를 진행할까요?") {
                        CommonUtil.goToAppStore()
                    } cancelCompletion: { [weak self] in
                        self?.viewModel.getLoginType()
                    }
                case .normal:
                    self?.viewModel.getLoginType()
                }
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
                        
                        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
                            guard error == nil, let token = user?.accessToken.tokenString else {
                                CommonUtil.showAlertView(withType: .default,
                                                         buttonType: .oneButton,
                                                         title: error?.localizedDescription,
                                                         description: error?.localizedDescription,
                                                         submitCompletion: { [weak self] in
                                    self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.rank), userData: nil)
                                }, cancelCompletion: nil)
                                
                                return
                            }
                            
                            user?.refreshTokensIfNeeded { refreshedUser, error in
                                guard error == nil, let token = refreshedUser?.accessToken.tokenString else {
                                    CommonUtil.showAlertView(withType: .default,
                                                             buttonType: .oneButton,
                                                             title: error?.localizedDescription,
                                                             description: error?.localizedDescription,
                                                             submitCompletion: { [weak self] in
                                        self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.rank), userData: nil)
                                    }, cancelCompletion: nil)
                                    
                                    return
                                }
                                
                                self?.viewModel.snsLogin(withToken: token, loginType: .google)
                            }
                        }
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
        
        viewModel.versionCheck()
    }
}
