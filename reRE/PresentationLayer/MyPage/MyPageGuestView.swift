//
//  MyPageGuestView.swift
//  reRE
//
//  Created by chihoooon on 2024/05/15.
//

import UIKit
import SnapKit
import Then

final class MyPageGuestView: UIView {
    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.red.cgColor
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "당신도 재평가의 역사에\n동참하세요"
        $0.textColor = ColorSet.gray(.gray60).color
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = FontSet.body01.font
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    lazy var loginButton = TouchableLabel().then {
        $0.text = "로그인 하러 가기"
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.button02.font
        $0.textAlignment = .center
        $0.backgroundColor = ColorSet.tertiary(.navy40).color
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.masksToBounds = true
    }
    
    lazy var settingButton = TouchableLabel().then {
        $0.text = "설정 보러 가기"
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.button03.font
        $0.textAlignment = .center
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(backgroundView)
        backgroundView.addSubviews([stackView, settingButton])
        stackView.addArrangedSubviews([imageView, descriptionLabel, loginButton])
        stackView.setCustomSpacing(moderateScale(number: 16), after: imageView)
        stackView.setCustomSpacing(moderateScale(number: 24), after: descriptionLabel)
    }
    
    private func makeConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 152))
        }
        
        loginButton.snp.makeConstraints {
            $0.width.equalTo(moderateScale(number: 176))
            $0.height.equalTo(moderateScale(number: 44))
        }
        
        settingButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(moderateScale(number: 8))
            $0.width.equalTo(moderateScale(number: 104))
            $0.height.equalTo(moderateScale(number: 32))
        }
    }
}
