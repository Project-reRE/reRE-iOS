//
//  BaseNavigationViewController.swift
//  reRE
//
//  Created by chihoooon on 2024/06/06.
//

import UIKit
import SnapKit
import Then

class BaseNavigationViewController: BaseViewController {
    lazy var topContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    lazy var backButton = TouchableImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "BackButtonIcon")
    }
    
    private lazy var topTitleLabel = UILabel().then {
        $0.textColor = ColorSet.tertiary(.navy90).color
        $0.font = FontSet.button01.font
        $0.numberOfLines = 0
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addViews() {
        view.addSubview(topContainerView)
        topContainerView.addSubviews([backButton, topTitleLabel])
    }
    
    override func makeConstraints() {
        topContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(getSafeAreaTop())
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 44))
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        topTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(backButton.snp.trailing).offset(moderateScale(number: 8))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
    }
    
    override func setupIfNeeded() {
        backButton.didTapped { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func setNavigationTitle(with title: String) {
        topTitleLabel.text = title
    }
}
