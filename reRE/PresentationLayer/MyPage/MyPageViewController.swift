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
    }
    
    private func bind() {
        StaticValues.isLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoggedIn in
                self?.guestView.isHidden = isLoggedIn
                self?.userView.isHidden = !isLoggedIn
            }.store(in: &cancelBag)
    }
}
