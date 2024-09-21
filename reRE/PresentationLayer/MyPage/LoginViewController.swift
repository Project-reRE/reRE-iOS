//
//  LoginViewController.swift
//  reRE
//
//  Created by 강치훈 on 7/8/24.
//

import UIKit
import AuthenticationServices
import Combine
import CryptoKit
import Then
import SnapKit
import KakaoSDKUser
import GoogleSignIn

final class LoginViewController: BaseBottomSheetViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    private var currentNonce: String?
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
            self?.kakaoLogin { [weak self] accessToken, error in
                guard error == nil,
                      let accessToken = accessToken else {
                    return
                }
                
                self?.viewModel.snsLogin(withToken: accessToken, loginType: .kakao)
            }
        }
        
        appleLoginButton.didTapped { [weak self] in
            self?.appleLogin()
        }
        
        googleLoginButton.didTapped { [weak self] in
            self?.googleLogin { [weak self] accessToken, error in
                guard error == nil,
                      let accessToken = accessToken else {
                    return
                }
                
                self?.viewModel.snsLogin(withToken: accessToken, loginType: .google)
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
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            completion(result?.user.accessToken.tokenString, error)
        }
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                
                LogDebug(error)
                
                if let userError = error as? UserError {
                    switch userError.statusCode {
                    case 401: // AccessToken Error
                        switch self.viewModel.currentSNSMethod {
                        case .kakao:
                            self.kakaoLogin { [weak self] accessToken, error in
                                guard error == nil,
                                      let accessToken = accessToken else {
                                    return
                                }
                                
                                self?.viewModel.snsLogin(withToken: accessToken, loginType: .kakao)
                            }
                        case .apple:
                            self.appleLogin()
                        case .google:
                            self.googleLogin { [weak self] accessToken, error in
                                guard error == nil,
                                      let accessToken = accessToken else {
                                    return
                                }
                                
                                self?.viewModel.snsLogin(withToken: accessToken, loginType: .google)
                            }
                        }
                    case 404: // Should SignUp
                        self.dismissBottomSheet { [weak self] in
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

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    private func appleLogin() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func decode(jwtToken jwt: String) -> [String: Any] {
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            
            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 += padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }
        
        func decodeJWTPart(_ value: String) -> [String: Any]? {
            guard let bodyData = base64UrlDecode(value),
                  let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
            }
            
            return payload
        }
        
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256( _ input: String) -> String {
        let inputData = Data(input.utf8)
        
        let hasedData = SHA256.hash(data: inputData)
        let hashString = hasedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? UIWindow()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            CommonUtil.hideLoadingView()
            return
        }
        
        viewModel.snsLogin(withToken: idTokenString, loginType: .apple)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // cancel, unknown
        guard (error as NSError).code != 1001,
              (error as NSError).code != 1000  else {
            CommonUtil.hideLoadingView()
            return
        }
    }
}
