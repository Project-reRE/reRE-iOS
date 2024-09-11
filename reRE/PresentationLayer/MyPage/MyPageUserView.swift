//
//  MyPageUserView.swift
//  reRE
//
//  Created by 강치훈 on 7/23/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class MyPageUserView: UIView {
    private lazy var thumbnailImageView = TouchableImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = moderateScale(number: 42)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.masksToBounds = true
        $0.kf.indicatorType = .activity
    }
    
    lazy var nicknameView = TouchableStackView().then {
        $0.spacing = moderateScale(number: 7)
        $0.alignment = .top
    }
    
    private lazy var nicknameLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.title02.font
    }
    
    private lazy var editImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "EditIcon")
    }
    
    private lazy var userInfoView = UIStackView().then {
        $0.spacing = moderateScale(number: 4)
        $0.alignment = .center
    }
    
    private lazy var genderLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray50).color
        $0.font = FontSet.subTitle01.font
    }
    
    private lazy var dividerCircleView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray50).color
        $0.layer.cornerRadius = moderateScale(number: 2)
        $0.layer.masksToBounds = true
    }
    
    private lazy var birthLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray50).color
        $0.font = FontSet.subTitle01.font
    }
    
    private lazy var revaluationStackView = UIStackView().then {
        $0.spacing = moderateScale(number: 4)
        $0.alignment = .center
    }
    
    private lazy var revaluationCountTitleLabel = UILabel().then {
        $0.text = "재평가한 콘텐츠 수:"
        $0.textColor = ColorSet.primary(.orange60).color
        $0.font = FontSet.subTitle01.font
    }
    
    private lazy var revaluationCountLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.gray70).color
        $0.font = FontSet.subTitle01.font
    }
    
    private lazy var emailTitleLabel = UILabel().then {
        $0.text = "이메일"
        $0.textColor = ColorSet.gray(.gray50).color
        $0.font = FontSet.title03.font
    }
    
    private lazy var emailContainerView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray20).color
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.masksToBounds = true
    }
    
    private lazy var snsImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var emailLabel = UILabel().then {
        $0.textColor = ColorSet.gray(.white).color
        $0.font = FontSet.body01.font
    }
    
    lazy var showNoticeButton = MyPageMenuView().then {
        $0.titleLabel.text = "공지사항 보기"
    }
    
    lazy var faqButton = MyPageMenuView().then {
        $0.titleLabel.text = "자주 묻는 질문과 답변 보기"
    }
    
    lazy var askButton = MyPageMenuView().then {
        $0.titleLabel.text = "이메일로 문의하기"
    }
    
    lazy var showSettingButton = MyPageMenuView().then {
        $0.titleLabel.text = "설정 보기"
    }
    
    lazy var logoutButton = MyPageMenuView().then {
        $0.titleLabel.text = "로그아웃하기"
        $0.titleLabel.font = FontSet.button02.font
        $0.titleLabel.textColor = ColorSet.gray(.gray40).color
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
        addSubviews([thumbnailImageView, nicknameView, userInfoView, revaluationStackView,
                     emailTitleLabel, emailContainerView, showNoticeButton, faqButton, askButton,
                     showSettingButton, logoutButton])
        
        nicknameView.addArrangedSubviews([nicknameLabel, editImageView])
        userInfoView.addArrangedSubviews([genderLabel, dividerCircleView, birthLabel])
        revaluationStackView.addArrangedSubviews([revaluationCountTitleLabel, revaluationCountLabel])
        emailContainerView.addSubviews([snsImageView, emailLabel])
    }
    
    private func makeConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 24))
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
            $0.size.equalTo(moderateScale(number: 84))
        }
        
        nicknameView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(moderateScale(number: 16))
            $0.top.equalTo(thumbnailImageView).inset(moderateScale(number: 11))
            $0.trailing.lessThanOrEqualToSuperview().inset(moderateScale(number: 16))
        }
        
        userInfoView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(moderateScale(number: 16))
            $0.top.equalTo(nicknameView.snp.bottom).offset(moderateScale(number: 4))
            $0.trailing.lessThanOrEqualToSuperview().inset(moderateScale(number: 16))
        }
        
        revaluationStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(moderateScale(number: 16))
            $0.top.equalTo(userInfoView.snp.bottom).offset(moderateScale(number: 12))
            $0.trailing.lessThanOrEqualToSuperview().inset(moderateScale(number: 16))
        }
        
        
        editImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 16))
        }
        
        dividerCircleView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 4))
        }
        
        emailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(moderateScale(number: 40))
            $0.leading.equalToSuperview().inset(moderateScale(number: 24))
        }
        
        emailContainerView.snp.makeConstraints {
            $0.top.equalTo(emailTitleLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        snsImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(moderateScale(number: 16))
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        emailLabel.snp.makeConstraints {
            $0.leading.equalTo(snsImageView.snp.trailing).offset(moderateScale(number: 8))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.centerY.equalTo(snsImageView)
        }
        
        showNoticeButton.snp.makeConstraints {
            $0.top.equalTo(emailContainerView.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        faqButton.snp.makeConstraints {
            $0.top.equalTo(showNoticeButton.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        askButton.snp.makeConstraints {
            $0.top.equalTo(faqButton.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        showSettingButton.snp.makeConstraints {
            $0.top.equalTo(askButton.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(showSettingButton.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
    }
    
    func updateView(withModel model: UserEntity) {
        nicknameLabel.text = model.nickName
        genderLabel.text = model.gender ? "남성" : "여성"
        revaluationCountLabel.text = "\(model.statistics.numRevaluations.formattedString())개"
        
        if let birthYear = model.birthDate.toDate(with: "yyyy-MM-dd")?.dateToString(with: "yyyy") {
            birthLabel.text = "\(birthYear)년생"
        }
        
        emailLabel.text = model.email
        thumbnailImageView.kf.setImage(with: URL(string: model.profileUrl))
        
        if let loginType = SNSLoginType(rawValue: model.provider) {
            switch loginType {
            case .kakao:
                snsImageView.image = UIImage(named: "MyPageKakaoIcon")
            case .apple:
                snsImageView.image = UIImage(named: "MyPageAppleIcon")
            }
        }
    }
}
