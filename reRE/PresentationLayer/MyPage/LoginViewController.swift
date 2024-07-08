//
//  LoginViewController.swift
//  reRE
//
//  Created by 강치훈 on 7/8/24.
//

import UIKit
import Then
import SnapKit
import KakaoSDKUser

final class LoginViewController: BaseBottomSheetViewController {
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
        
        kakaoLoginButton.didTapped {
//            if UserApi.isKakaoTalkLoginAvailable() {
//                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
//                    print("카카오톡으로 로그인 !!!")
//                    guard error == nil else {
//                        print("error: \(error)")
//                        return
//                    }
//                    
//                    print("oauthToken?.accessToken: \(oauthToken?.accessToken)")
//                    print("oauthToken?.idToken: \(oauthToken?.idToken)")
//                }
//            } else {
//                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
//                    print("카카오 계정으로 로그인 !!!")
//                    guard error == nil else {
//                        print("error: \(error)")
//                        return
//                    }
//                    
//                    print("oauthToken?.accessToken: \(oauthToken?.accessToken)")
//                    print("oauthToken?.idToken: \(oauthToken?.idToken)")
//                }
//            }
        }
        
        appleLoginButton.didTapped {
            
        }
    }
    
    private func bind() {
        
    }
}
