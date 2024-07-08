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
        $0.text = "카카오 로그인"
        $0.font = FontSet.button02.font
        $0.textColor = ColorSet.gray(.black).color
    }
    
    private lazy var appleLoginButton = TouchableView().then {
        $0.backgroundColor = ColorSet.gray(.white).color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.layer.masksToBounds = true
    }
    
    private lazy var appleIcon = UIImageView().then {
        $0.image = UIImage(named: "AppleIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var appleTitleLabel = UILabel().then {
        $0.text = "Apple 로그인"
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
        
        bottomSheetContainerView.addSubviews([kakaoLoginButton, appleLoginButton])
        kakaoLoginButton.addSubviews([kakaoIcon, kakaoTitleLabel])
        appleLoginButton.addSubviews([appleIcon, appleTitleLabel])
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
            $0.bottom.equalToSuperview().inset(getSafeAreaBottom())
        }
        
        [kakaoIcon, appleIcon].forEach { subView in
            subView.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(moderateScale(number: 16))
                $0.top.equalToSuperview().inset(moderateScale(number: 14))
                $0.bottom.equalToSuperview().inset(moderateScale(number: 18))
                $0.size.equalTo(moderateScale(number: 24))
            }
        }
        
        [kakaoTitleLabel, appleTitleLabel].forEach { subView in
            subView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        bottomSheetContainerView.backgroundColor = .clear
        
        kakaoLoginButton.didTapped { [weak self] in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                    guard error == nil,
                          let accessToken = oauthToken?.accessToken else {
                        return
                    }
                    
                    print("accessToken: \(accessToken)")
                    self?.viewModel.snsLogin(withToken: accessToken)
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
                    guard error == nil,
                          let accessToken = oauthToken?.accessToken else {
                        return
                    }
                    
                    print("accessToken: \(accessToken)")
                    self?.viewModel.snsLogin(withToken: accessToken)
                }
            }
        }
        
        appleLoginButton.didTapped {
            
        }
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .sink { error in
                LogDebug(error)
            }.store(in: &cancelBag)
        
        viewModel.getjwtPublisher()
            .droppedSink { jwt in
                print("jwt: \(jwt)")
            }.store(in: &cancelBag)
    }
}
