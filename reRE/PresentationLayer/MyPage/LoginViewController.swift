//
//  LoginViewController.swift
//  reRE
//
//  Created by 강치훈 on 7/8/24.
//

import UIKit
import Combine
import Then
import SnapKit
import KakaoSDKUser
import GoogleSignIn

final class LoginViewController: BaseBottomSheetViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    var coordinator: CommonBaseCoordinator?
    
    private lazy var kakaoLoginButton = TouchableView().then {
        $0.backgroundColor = UIColor(red: 0.996, green: 0.898, blue: 0, alpha: 1)
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.layer.masksToBounds = true
    }
    
    private lazy var kakaoIcon = UIImageView().then {
        $0.image = UIImage(named: "KakaoIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var kakaoTitleLabel = UILabel().then {
        $0.text = "카카오로 계속하기"
        $0.font = FontSet.button02.font
        $0.textColor = ColorSet.gray(.black).color
    }
    
    private lazy var appleLoginButton = TouchableView().then {
        $0.backgroundColor = ColorSet.gray(.black).color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.layer.masksToBounds = true
        $0.layer.borderColor = ColorSet.gray(.white).color?.cgColor
        $0.layer.borderWidth = moderateScale(number: 1)
    }
    
    private lazy var appleIcon = UIImageView().then {
        $0.image = UIImage(named: "AppleIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var appleTitleLabel = UILabel().then {
        $0.text = "Apple로 로그인하기"
        $0.font = FontSet.button02.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var googleLoginButton = TouchableView().then {
        $0.backgroundColor = ColorSet.gray(.white).color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.layer.masksToBounds = true
    }
    
    private lazy var googleIcon = UIImageView().then {
        $0.image = UIImage(named: "GoogleIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var googleTitleLabel = UILabel().then {
        $0.text = "Google로 로그인하기"
        $0.font = FontSet.button02.font
        $0.textColor = ColorSet.gray(.black).color
    }
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func addViews() {
        super.addViews()
        
        bottomSheetContainerView.addSubviews([kakaoLoginButton, appleLoginButton, googleLoginButton])
        kakaoLoginButton.addSubviews([kakaoIcon, kakaoTitleLabel])
        appleLoginButton.addSubviews([appleIcon, appleTitleLabel])
        googleLoginButton.addSubviews([googleIcon, googleTitleLabel])
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        bottomSheetContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.snp.bottom)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 56))
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 56))
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 56))
            $0.bottom.equalToSuperview().inset(getSafeAreaBottom())
        }
        
        [kakaoIcon, appleIcon, googleIcon].forEach { subView in
            subView.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(moderateScale(number: 16))
                $0.top.equalToSuperview().inset(moderateScale(number: 14))
                $0.bottom.equalToSuperview().inset(moderateScale(number: 18))
                $0.size.equalTo(moderateScale(number: 24))
            }
        }
        
        [kakaoTitleLabel, appleTitleLabel, googleTitleLabel].forEach { subView in
            subView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        bottomSheetContainerView.backgroundColor = .clear
        
        kakaoLoginButton.didTapped { [weak self] in
            self?.kakaoLogin { accessToken, error in
                guard error == nil,
                      let accessToken = accessToken else {
                    return
                }
                
                self?.viewModel.snsLogin(withToken: accessToken, loginType: .kakao)
            }
        }
        
        appleLoginButton.didTapped {
            
        }
        
        googleLoginButton.didTapped { [weak self] in
            self?.googleLogin { _, _ in
                print("good")
            }
        }
    }
    
    private func kakaoLogin(_ completion: @escaping (String?, Error?) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                completion(oauthToken?.accessToken, error)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                completion(oauthToken?.accessToken, error)
            }
        }
    }
    
    private func googleLogin(_ completion: @escaping (String?, Error?) -> Void) {
        let clientID: String = StaticValues.googleClientId
        // 구글 인증
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
//            guard error == nil else { return }
//            
//            // 인증을 해도 계정은 따로 등록을 해주어야 한다.
//            // 구글 인증 토큰 받아서 -> 사용자 정보 토큰 생성 -> 파이어베이스 인증에 등록
//            guard
//                let authentication = user?.authentication,
//                let idToken = authentication.idToken
//            else {
//                return
//            }
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                           accessToken: authentication.accessToken)
//            
//            // 사용자 정보 등록
//            Auth.auth().signIn(with: credential) { _, _ in
//                // 사용자 등록 후에 처리할 코드
//            }
//            // If sign in succeeded, display the app's main content View.
//        }
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            print("result?.user.idToken?.tokenString: \(result?.user.idToken?.tokenString)")
            print("result?.user.accessToken.tokenString: \(result?.user.accessToken.tokenString)")
            
            completion(result?.user.accessToken.tokenString, error)
        }
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                
                LogDebug(error)
                
                if let userError = error as? UserError {
                    switch userError.statusCode {
                    case 401: // AccessToken Error
                        self?.kakaoLogin { [weak self] accessToken, error in
                            guard error == nil,
                                  let accessToken = accessToken else {
                                return
                            }
                            
                            self?.viewModel.snsLogin(withToken: accessToken, loginType: .kakao)
                        }
                    case 404: // Should SignUp
                        self?.dismissBottomSheet { [weak self] in
                            guard let self = self else { return }
                            
                            self.coordinator?.moveTo(appFlow: TabBarFlow.common(.signUp),
                                                     userData: ["viewModel": self.viewModel])
                        }
                    default:
                        CommonUtil.showAlertView(withType: .default,
                                                 buttonType: .oneButton,
                                                 title: "statueCode: \(userError.statusCode)",
                                                 description: userError.message.first,
                                                 submitCompletion: nil,
                                                 cancelCompletion: nil)
                    }
                } else {
                    CommonUtil.showAlertView(withType: .default,
                                             buttonType: .oneButton,
                                             title: error.localizedDescription,
                                             description: error.localizedDescription,
                                             submitCompletion: nil,
                                             cancelCompletion: nil)
                }
            }.store(in: &cancelBag)
        
        viewModel.getLoginCompletionPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismissBottomSheet()
            }.store(in: &cancelBag)
    }
}
