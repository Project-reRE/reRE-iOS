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

final class MyPageViewController: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    
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
                                     submitCompletion: {
                print("닉네임 변경")
            }, cancelCompletion: nil)
        }
        
        userView.showNoticeButton.containerView.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.web),
                                      userData: ["urlString": StaticValues.noticeUrlString])
        }
        
        userView.faqButton.containerView.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.web),
                                      userData: ["urlString": StaticValues.faqUrlString])
        }
        
        userView.askButton.containerView.didTapped { [weak self] in
            UIPasteboard.general.string = StaticValues.inquiryEmail
            self?.showToastMessageView(title: "메일 주소가 복사되었어요.")
        }
        
        userView.showSettingButton.containerView.didTapped { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.myPage(.appSetting(.main)), userData: nil)
        }
        
        userView.logoutButton.containerView.didTapped {
            
        }
    }
    
    private func bind() {
        viewModel.getMyProfilePublisher()
            .droppedSink { [weak self] myProfileModel in
                print("myProfileModel: \(myProfileModel)")
                self?.userView.updateView(withModel: myProfileModel)
            }.store(in: &cancelBag)
        
        StaticValues.isLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoggedIn in
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
        alertVC.updateTextFieldDescriptionLabel(withText: text)
    }
}
