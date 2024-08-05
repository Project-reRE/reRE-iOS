//
//  SignUpViewController.swift
//  reRE
//
//  Created by 강치훈 on 7/10/24.
//

import UIKit
import Combine
import Then
import SnapKit
import KakaoSDKUser

final class SignUpViewController: BaseNavigationViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    var coordinator: CommonBaseCoordinator?
    
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
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.red.cgColor
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
        $0.spacing = moderateScale(number: 7)
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
                                   yearOfBirthTextField, genderTitleLabel, genderButtonStackView,
                                   termsStackView])
        yearOfBirthTextField.addSubview(clearButton)
        genderButtonStackView.addArrangedSubviews([maleButton, femaleButton])
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
            $0.bottom.equalToSuperview().inset(moderateScale(number: 38 + 52))
        }
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(moderateScale(number: 38))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 52))
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
        
        yearOfBirthTextField.snp.makeConstraints {
            $0.top.equalTo(yearOfBirthTitleLabel.snp.bottom).offset(moderateScale(number: 12))
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
        
        clearButton.didTapped { [weak self] in
            self?.yearOfBirthTextField.text = ""
            self?.clearButton.isHidden = true
            self?.viewModel.setUserBirth(withYear: "")
        }
        
        maleButton.didTapped { [weak self] in
            self?.maleButton.backgroundColor = ColorSet.primary(.darkGreen40).color
            self?.maleButton.textColor = ColorSet.gray(.white).color
            
            self?.femaleButton.backgroundColor = .clear
            self?.femaleButton.textColor = ColorSet.gray(.gray50).color
            
            self?.viewModel.setUserGender(isMale: true)
        }
        
        femaleButton.didTapped { [weak self] in
            self?.femaleButton.backgroundColor = ColorSet.primary(.darkGreen40).color
            self?.femaleButton.textColor = ColorSet.gray(.white).color
            
            self?.maleButton.backgroundColor = .clear
            self?.maleButton.textColor = ColorSet.gray(.gray50).color
            
            self?.viewModel.setUserGender(isMale: false)
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
            self?.viewModel.signUp()
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
                    default:
                        break
                    }
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
                print("login success")
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
