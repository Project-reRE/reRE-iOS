//
//  MyPageViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit
import Combine
import Then
import SnapKit
import KakaoSDKUser
import GoogleSignIn

final class MyPageViewController: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    private var updatedNickname: String?
    
    var coordinator: MyPageBaseCoordinator?
    
    private lazy var topContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "내 정보"
        $0.font = FontSet.display02.font
        $0.textColor = ColorSet.gray(.white).color
    }
    
    private lazy var guestView = MyPageGuestView()
    private lazy var userView = MyPageUserView()
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.gray(.gray10).color
        
        bind()
    }
    
    override func addViews() {
        view.addSubviews([topContainerView, guestView, userView])
        topContainerView.addSubview(titleLabel)
    }
    
    override func makeConstraints() {
        topContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(getSafeAreaTop())
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 44))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        guestView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        userView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(BaseTabBar.tabBarHeight + getSafeAreaBottom())
        }
    }
    
    override func setupIfNeeded() {
        guestView.loginButton.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.login), userData: nil)
        }
        
        guestView.settingButton.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.myPage(.appSetting(.main)), userData: nil)
        }
        
        userView.nicknameView.didTapped {
            CommonUtil.showAlertView(withType: .textField,
                                     buttonType: .twoButton,
                                     title: "닉네임 변경하기",
                                     description: nil,
                                     delegate: self,
                                     submitText: "변경",
                                     cancelText: "취소",
                                     submitCompletion: { [weak self] in
                guard let nickname = self?.updatedNickname else { return }
                self?.viewModel.updateNickname(with: nickname)
            }, cancelCompletion: nil)
        }
        
        userView.showNoticeButton.containerView.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.web),
                                      userData: ["webViewType": WebViewType.notice])
        }
        
        userView.faqButton.containerView.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.web),
                                      userData: ["webViewType": WebViewType.faq])
        }
        
        userView.askButton.containerView.didTapped { [weak self] in
            UIPasteboard.general.string = StaticValues.inquiryEmail
            self?.showToastMessageView(title: "메일 주소가 복사되었어요.")
        }
        
        userView.showSettingButton.containerView.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.myPage(.appSetting(.main)), userData: nil)
        }
        
        userView.logoutButton.containerView.didTapped { [weak self] in
            guard let loginType = self?.viewModel.getLoginType() else {
                CommonUtil.showAlertView(withType: .default,
                                         buttonType: .oneButton,
                                         title: "로그아웃에 실패 했습니다.",
                                         description: "로그인 되어 있지 않은 유저입니다.",
                                         submitCompletion: nil,
                                         cancelCompletion: nil)
                return
            }
            
            switch loginType {
            case .kakao:
                UserApi.shared.logout { [weak self] error in
                    guard error == nil else {
                        CommonUtil.showAlertView(withType: .default,
                                                 buttonType: .oneButton,
                                                 title: "로그아웃에 실패 했습니다.",
                                                 description: error?.localizedDescription,
                                                 submitCompletion: nil,
                                                 cancelCompletion: nil)
                        
                        return
                    }
                    
                    self?.viewModel.logout()
                }
            case .apple:
                self?.viewModel.logout()
            case .google:
                GIDSignIn.sharedInstance.signOut()
                self?.viewModel.logout()
            }
        }
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .mainSink { [weak self] error in
                LogDebug(error)
                
                if let userError = error as? UserError {
                    switch userError.statusCode {
                    case 409:
                        guard let alertVC = CommonUtil.topViewController() as? AlertViewController else { return }
                        alertVC.updateTextFieldDescriptionLabel(withText: "이미 등록된 닉네임이에요.",
                                                                isErrorOccured: true)
                    default:
                        CommonUtil.hideAlertView {
                            CommonUtil.showAlertView(withType: .default,
                                                     buttonType: .oneButton,
                                                     title: "statueCode: \(userError.statusCode)",
                                                     description: userError.message.first,
                                                     submitCompletion: nil,
                                                     cancelCompletion: nil)
                        }
                    }
                } else {
                    CommonUtil.hideAlertView {
                        CommonUtil.showAlertView(withType: .default,
                                                 buttonType: .oneButton,
                                                 title: error.localizedDescription,
                                                 description: error.localizedDescription,
                                                 submitCompletion: nil,
                                                 cancelCompletion: nil)
                    }
                }
            }.store(in: &cancelBag)
        
        viewModel.getMyProfilePublisher()
            .droppedSink { [weak self] myProfileModel in
                if let alertVC = CommonUtil.topViewController() as? AlertViewController {
                    alertVC.dismiss(animated: false)
                }
                
                self?.userView.updateView(withModel: myProfileModel)
            }.store(in: &cancelBag)
        
        StaticValues.isLoggedIn
            .mainSink { [weak self] isLoggedIn in
                if isLoggedIn {
                    self?.viewModel.getMyProfile()
                }
                
                self?.guestView.isHidden = isLoggedIn
                self?.userView.isHidden = !isLoggedIn
            }.store(in: &cancelBag)
    }
}

// MARK: - AlertViewControllerDelegate
extension MyPageViewController: AlertViewControllerDelegate {
    func textFieldDidChange(withText text: String) {
        guard let alertVC = CommonUtil.topViewController() as? AlertViewController else { return }
        
        updatedNickname = text
        
        guard !text.isEmpty else {
            alertVC.updateTextFieldDescriptionLabel(withText: "", isErrorOccured: false)
            return
        }
        
        if text.isValidNickname() {
            alertVC.updateTextFieldDescriptionLabel(withText: "", isErrorOccured: false)
            
            alertVC.confirmButton.isUserInteractionEnabled = true
            alertVC.confirmButton.textColor = ColorSet.gray(.white).color
            alertVC.confirmButton.backgroundColor = ColorSet.primary(.orange50).color
        } else {
            alertVC.updateTextFieldDescriptionLabel(withText: "2자 이상 15자 이하, 특수문자 없이 입력할 수 있어요.",
                                                    isErrorOccured: true)
            
            alertVC.confirmButton.isUserInteractionEnabled = false
            alertVC.confirmButton.textColor = ColorSet.gray(.gray60).color
            alertVC.confirmButton.backgroundColor = ColorSet.gray(.gray30).color
        }
    }
}
