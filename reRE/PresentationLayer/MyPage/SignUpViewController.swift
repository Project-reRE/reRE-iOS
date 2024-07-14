//
//  SignUpViewController.swift
//  reRE
//
//  Created by 강치훈 on 7/10/24.
//

import UIKit
import Then
import SnapKit

final class SignUpViewController: NavigationBaseViewController {
    var coordinator: CommonBaseCoordinator?
    
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
        $0.layer.borderColor = ColorSet.gray(.gray40).color?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.masksToBounds = true
        $0.backgroundColor = .clear
        $0.textAlignment = .center
    }
    
    private lazy var femaleButton = TouchableLabel().then {
        $0.text = "여성"
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
    }
    
    private let viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init()
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
}
