//
//  MyPageViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/04/10.
//

import UIKit
import Then
import SnapKit

final class MyPageViewController: BaseViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.gray(.gray10).color
    }
    
    override func addViews() {
        view.addSubviews([topContainerView, guestView])
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
    }
    
    override func setupIfNeeded() {
        guestView.loginButton.setOpaqueTapGestureRecognizer {
            
        }
        
        guestView.settingButton.setOpaqueTapGestureRecognizer {
            
        }
    }
}
