//
//  SignUpViewController.swift
//  reRE
//
//  Created by 강치훈 on 7/10/24.
//

import UIKit
import AuthenticationServices
import Combine
import CryptoKit
import Then
import SnapKit
import KakaoSDKUser
import GoogleSignIn

final class SignUpViewController: BaseNavigationViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    private var currentNonce: String?
    var coordinator: CommonBaseCoordinator?
    private var buttonBottomConstraints: Constraint?
    
    private var isAllChecked: Bool = false {
        didSet {
            allAgreeButton.updateCheckStatus(isChecked: isAllChecked)
        }
    }
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "SignUpIcon")
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "거의 다 되었어요!"
        $0.font = FontSet.display02.font
        $0.textColor = ColorSet.primary(.darkGreen60).color
        $0.textAlignment = .center
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "이제 간략한 정보 입력과 동의만 하시면\n재평가의 역사에 참여하실 수 있어요!"
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.gray70).color
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var yearOfBirthTitleLabel = UILabel().then {
        $0.text = "출생연도"
        $0.font = FontSet.title02.font
        $0.textColor = ColorSet.gray(.gray80).color
    }
    
    private lazy var openBirthButton = ToggleButton().then {
        $0.titleLabel.text = "공개"
        $0.updateRadioButton(isSelected: true)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var privateBirthButton = ToggleButton().then {
        $0.titleLabel.text = "비공개"
        $0.updateRadioButton(isSelected: false)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var yearOfBirthTextField = UITextField().then {
        $0.backgroundColor = ColorSet.gray(.gray20).color
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.masksToBounds = true
        $0.textColor = ColorSet.gray(.gray70).color
        $0.font = FontSet.body03.font
        $0.delegate = self
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        $0.keyboardType = .numberPad
        $0.addRightPadding(moderateScale(number: 8 + 20 + 8))
        $0.addLeftPadding(moderateScale(number: 16))
        $0.setCustomPlaceholder(placeholder: "숫자로 4글자 입력해 주세요 (예.2010)",
                                color: ColorSet.gray(.gray50).color,
                                font: FontSet.body03.font)
    }
    
    private lazy var clearButton = TouchableImageView(frame: .zero).then {
        $0.image = UIImage(named: "ClearButton")
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private lazy var genderTitleLabel = UILabel().then {
        $0.text = "성별"
        $0.font = FontSet.title02.font
        $0.textColor = ColorSet.gray(.gray80).color
    }
    
    private lazy var genderButtonStackView = UIStackView().then {
        $0.spacing = moderateScale(number: 8)
        $0.distribution = .fillEqually
    }
    
    private lazy var maleButton = TouchableLabel().then {
        $0.text = "남성"
        $0.textColor = ColorSet.gray(.gray50).color
        $0.font = FontSet.button02.font
        $0.layer.borderColor = ColorSet.gray(.gray40).color?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.masksToBounds = true
        $0.backgroundColor = .clear
        $0.textAlignment = .center
    }
    
    private lazy var femaleButton = TouchableLabel().then {
        $0.text = "여성"
        $0.textColor = ColorSet.gray(.gray50).color
        $0.font = FontSet.button02.font
        $0.layer.borderColor = ColorSet.gray(.gray40).color?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.masksToBounds = true
        $0.backgroundColor = .clear
        $0.textAlignment = .center
    }
    
    private lazy var privateGenderButton = TouchableLabel().then {
        $0.text = "비공개"
        $0.textColor = ColorSet.gray(.gray50).color
        $0.font = FontSet.button02.font
        $0.layer.borderColor = ColorSet.gray(.gray40).color?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.masksToBounds = true
        $0.backgroundColor = .clear
        $0.textAlignment = .center
    }
    
    private lazy var termsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderateScale(number: 12)
    }
    
    private lazy var allAgreeButton = TermsStackView().then {
        $0.updateView(withTitle: "모두 동의하기")
        $0.titleLabel.font = FontSet.title03.font
        $0.titleLabel.textColor = ColorSet.gray(.gray70).color
        $0.showTermsButton.isHidden = true
    }
    
    private lazy var dividerView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray30).color
    }
    
    private lazy var ageAgreementButton = TermsStackView().then {
        $0.updateView(withTitle: "(필수) 만 14세 이상이에요.")
        $0.showTermsButton.isHidden = true
    }
    
    private lazy var serviceAgreementButton = TermsStackView().then {
        $0.updateView(withTitle: "(필수) 서비스 이용약관 동의하기")
    }
    
    private lazy var privacyPolicyAgreementButton = TermsStackView().then {
        $0.updateView(withTitle: "(필수) 개인정보 수집 및 이용 동의하기")
    }
    
    private lazy var signUpButton = TouchableLabel().then {
        $0.text = "회원 가입 및 로그인하기"
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.backgroundColor = ColorSet.gray(.gray30).color
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.button01.font
        $0.isUserInteractionEnabled = false
    }
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
        
        hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([scrollView, signUpButton])
        scrollView.addSubview(containerView)
        containerView.addSubviews([imageView, titleLabel, descriptionLabel, yearOfBirthTitleLabel,
                                   openBirthButton, privateBirthButton, yearOfBirthTextField,
                                   genderTitleLabel, genderButtonStackView, termsStackView])
        yearOfBirthTextField.addSubview(clearButton)
        genderButtonStackView.addArrangedSubviews([maleButton, femaleButton, privateGenderButton])
        termsStackView.addArrangedSubviews([allAgreeButton, dividerView, ageAgreementButton,
                                            serviceAgreementButton, privacyPolicyAgreementButton])
        termsStackView.setCustomSpacing(moderateScale(number: 16), after: allAgreeButton)
        termsStackView.setCustomSpacing(moderateScale(number: 16), after: dividerView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalToSuperview().inset(getDefaultSafeAreaBottom() + moderateScale(number: 52))
        }
        
        signUpButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 52))
            buttonBottomConstraints = $0.bottom.equalToSuperview().inset(getDefaultSafeAreaBottom()).constraint
        }
        
        containerView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 40))
            $0.centerX.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 152))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(moderateScale(number: 24))
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.centerX.equalToSuperview()
        }
        
        yearOfBirthTitleLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(moderateScale(number: 40))
            $0.leading.equalToSuperview().inset(moderateScale(number: 24))
        }
        
        openBirthButton.snp.makeConstraints {
            $0.top.equalTo(yearOfBirthTitleLabel.snp.bottom).offset(moderateScale(number: 12))
            $0.leading.equalToSuperview().inset(moderateScale(number: 24))
        }
        
        privateBirthButton.snp.makeConstraints {
            $0.centerY.equalTo(openBirthButton)
            $0.leading.equalTo(openBirthButton.snp.trailing).offset(moderateScale(number: 28))
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        yearOfBirthTextField.snp.makeConstraints {
            $0.top.equalTo(openBirthButton.snp.bottom).offset(moderateScale(number: 12))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 48))
        }
        
        clearButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(moderateScale(number: 8))
            $0.size.equalTo(moderateScale(number: 20))
        }
        
        genderTitleLabel.snp.makeConstraints {
            $0.top.equalTo(yearOfBirthTextField.snp.bottom).offset(moderateScale(number: 20))
            $0.leading.equalToSuperview().inset(moderateScale(number: 24))
        }
        
        genderButtonStackView.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(moderateScale(number: 12))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 44))
        }
        
        termsStackView.snp.makeConstraints {
            $0.top.equalTo(genderButtonStackView.snp.bottom).offset(moderateScale(number: 35))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.bottom.equalToSuperview().inset(moderateScale(number: 166))
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        openBirthButton.didTapped { [weak self] in
            guard let self = self else { return }
            guard !self.openBirthButton.isSelected else { return }
            
            self.openBirthButton.updateRadioButton(isSelected: true)
            self.privateBirthButton.updateRadioButton(isSelected: false)
            
            self.yearOfBirthTextField.snp.updateConstraints {
                $0.height.equalTo(moderateScale(number: 48))
            }
            
            self.viewModel.setUserBirth(withYear: "")
        }
        
        privateBirthButton.didTapped { [weak self] in
            guard let self = self else { return }
            guard !self.privateBirthButton.isSelected else { return }
            
            self.privateBirthButton.updateRadioButton(isSelected: true)
            self.openBirthButton.updateRadioButton(isSelected: false)
            
            self.yearOfBirthTextField.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            
            self.clearTextField()
        }
        
        clearButton.didTapped { [weak self] in
            self?.clearTextField()
        }
        
        maleButton.didTapped { [weak self] in
            guard let self = self else { return }
            
            for arrangedSubView in self.genderButtonStackView.arrangedSubviews {
                if arrangedSubView == self.maleButton {
                    (arrangedSubView as? TouchableLabel)?.backgroundColor = ColorSet.primary(.darkGreen40).color
                    (arrangedSubView as? TouchableLabel)?.textColor = ColorSet.gray(.white).color
                } else {
                    (arrangedSubView as? TouchableLabel)?.backgroundColor = .clear
                    (arrangedSubView as? TouchableLabel)?.textColor = ColorSet.gray(.gray50).color
                }
            }
            
            self.viewModel.setUserGender(to: .male)
        }
        
        femaleButton.didTapped { [weak self] in
            guard let self = self else { return }
            
            for arrangedSubView in self.genderButtonStackView.arrangedSubviews {
                if arrangedSubView == self.femaleButton {
                    (arrangedSubView as? TouchableLabel)?.backgroundColor = ColorSet.primary(.darkGreen40).color
                    (arrangedSubView as? TouchableLabel)?.textColor = ColorSet.gray(.white).color
                } else {
                    (arrangedSubView as? TouchableLabel)?.backgroundColor = .clear
                    (arrangedSubView as? TouchableLabel)?.textColor = ColorSet.gray(.gray50).color
                }
            }
            
            self.viewModel.setUserGender(to: .female)
        }
        
        privateGenderButton.didTapped { [weak self] in
            guard let self = self else { return }
            
            for arrangedSubView in self.genderButtonStackView.arrangedSubviews {
                if arrangedSubView == self.privateGenderButton {
                    (arrangedSubView as? TouchableLabel)?.backgroundColor = ColorSet.primary(.darkGreen40).color
                    (arrangedSubView as? TouchableLabel)?.textColor = ColorSet.gray(.white).color
                } else {
                    (arrangedSubView as? TouchableLabel)?.backgroundColor = .clear
                    (arrangedSubView as? TouchableLabel)?.textColor = ColorSet.gray(.gray50).color
                }
            }
            
            self.viewModel.setUserGender(to: .unknown)
        }
        
        allAgreeButton.didTapped { [weak self] in
            guard let self = self else { return }
            
            var isChecked: Bool = self.allAgreeButton.getCheckedValue()
            isChecked.toggle()
            
            self.termsStackView.arrangedSubviews.forEach { subView in
                (subView as? TermsStackView)?.updateCheckStatus(isChecked: isChecked)
            }
            
            self.isAllChecked = isChecked
        }
        
        serviceAgreementButton.showTermsButton.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.web),
                                      userData: ["webViewType": WebViewType.serviceAgreement])
        }
        
        privacyPolicyAgreementButton.showTermsButton.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.web),
                                      userData: ["webViewType": WebViewType.privacyPolicy])
        }
        
        signUpButton.didTapped { [weak self] in
            guard let self = self else { return }
            guard self.viewModel.canSignUpAge() else {
                CommonUtil.showAlertView(withType: .default,
                                         buttonType: .oneButton,
                                         title: "회원 가입하기",
                                         description: "만 14세 미만은 가입이 불가능해요.",
                                         submitCompletion: nil,
                                         cancelCompletion: nil)
                return
            }
            
            self.viewModel.signUp()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func deinitialize() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .mainSink { [weak self] error in
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
        
        ageAgreementButton.getCheckPublisher()
            .combineLatest(serviceAgreementButton.getCheckPublisher(),
                           privacyPolicyAgreementButton.getCheckPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ageAgreement, serviceAgreement, privacyPolicyAgreement in
                let isAllAgree: Bool = ageAgreement && serviceAgreement && privacyPolicyAgreement
                
                self?.isAllChecked = isAllAgree
                self?.viewModel.setUserAgreement(isAllAgree: isAllAgree)
            }.store(in: &cancelBag)
        
        viewModel.getSatisfiedConditionPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSatisfied in
                self?.signUpButton.isUserInteractionEnabled = isSatisfied
                
                if isSatisfied {
                    self?.signUpButton.backgroundColor = ColorSet.primary(.orange50).color
                    self?.signUpButton.textColor = ColorSet.gray(.white).color
                } else {
                    self?.signUpButton.backgroundColor = ColorSet.gray(.gray30).color
                    self?.signUpButton.textColor = ColorSet.gray(.gray60).color
                }
            }.store(in: &cancelBag)
        
        viewModel.getLoginCompletionPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancelBag)
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
    
    private func clearTextField() {
        yearOfBirthTextField.text = ""
        clearButton.isHidden = true
        viewModel.setUserBirth(withYear: nil)
    }
    
    @objc
    private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    private func textFieldDidChange(_ sender: UITextField) {
        guard let userBirth = sender.text else { return }
        
        clearButton.isHidden = userBirth.isEmpty
        viewModel.setUserBirth(withYear: userBirth)
    }
    
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] keyboardFrame in
            guard let self = self else { return }
            buttonBottomConstraints?.update(inset: keyboardFrame.height + moderateScale(number: 12))
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] _ in
            self?.buttonBottomConstraints?.update(inset: getDefaultSafeAreaBottom())
        }
    }
}

extension SignUpViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
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

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty,
              let text = textField.text else {
            return true
        }
        
        let isNumeric: Bool = string.isEmpty || (Double(string) != nil)
        return isNumeric && text.count < 4
    }
}
