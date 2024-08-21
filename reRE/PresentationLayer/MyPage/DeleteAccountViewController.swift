//
//  DeleteAccountViewController.swift
//  reRE
//
//  Created by 강치훈 on 8/21/24.
//

import UIKit
import Combine
import Then
import SnapKit

final class DeleteAccountViewController: BaseNavigationViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    var coordinator: MyPageBaseCoordinator?
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var holdUserTitleLabel = UILabel().then {
        $0.text = "정말로 탈퇴하시겠어요?"
        $0.font = FontSet.body01.font
        $0.textColor = ColorSet.gray(.gray70).color
        $0.textAlignment = .center
    }
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var holeUserDescriptionLabel = UILabel().then {
        $0.text = "아직 당신의 현명한 재평가를 기다리는 콘텐츠가 있어요.\n재평가를 통해 다시 한 번 영화의 가치를 판단해 주세요."
        $0.font = FontSet.body03.font
        $0.textColor = ColorSet.gray(.gray70).color
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var quoteConatinerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var leftQuotesIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "LeftQuotes")
    }
    
    private lazy var quoteTextLabel = UILabel().then {
        $0.text = "내가 그를 만나고 싶다고 말해줘.\n그리고 나에게 다시 돌아와 달라고."
        $0.font = FontSet.title02.font
        $0.textColor = ColorSet.primary(.orange70).color
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var quoteMovieLabel = UILabel().then {
        $0.text = "- 영화 러브 액츄얼리에서"
        $0.font = FontSet.subTitle01.font
        $0.textColor = ColorSet.gray(.gray60).color
        $0.textAlignment = .center
    }
    
    private lazy var rightQuotesIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "RightQuotes")
    }
    
    private lazy var precautionTitleLabel = UILabel().then {
        $0.text = "탈퇴 시, 유의사항"
        $0.font = FontSet.title03.font
        $0.textColor = ColorSet.gray(.gray70).color
    }
    
    private lazy var precautionContainerView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray20).color
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var firstTextLabel = UILabel().then {
        $0.text = "1. "
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray60).color
    }
    
    private lazy var firstPrecautionLabel = UILabel().then {
        $0.text = "탈퇴 시, 작성한 콘텐츠는 삭제되지 않습니다."
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray60).color
        $0.numberOfLines = 0
    }
    
    private lazy var secondTextLabel = UILabel().then {
        $0.text = "2. "
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray60).color
    }
    
    private lazy var secondPrecautionLabel = UILabel().then {
        $0.text = "탈퇴 시, 삭제된 회원 및 계정 정보는 복구할 수 없습니다."
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray60).color
        $0.numberOfLines = 0
    }
    
    private lazy var thirdTextLabel = UILabel().then {
        $0.text = "3. "
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray60).color
    }
    
    private lazy var thirdPrecautionLabel = UILabel().then {
        $0.text = "탈퇴 시, 관련 법령 상 보관 의무가 있는 정보를 제외한 회원 및 계정 정보는 삭제됩니다."
        $0.font = FontSet.body04.font
        $0.textColor = ColorSet.gray(.gray60).color
        $0.numberOfLines = 0
    }
    
    private lazy var checkPrecautionButton = TermsStackView().then {
        $0.updateView(withTitle: "위의 내용을 확인하였으며 모두 동의합니다.")
        $0.showTermsButton.isHidden = true
    }
    
    private lazy var deleteAccountButton = TouchableLabel().then {
        $0.text = "회원 탈퇴하기"
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.backgroundColor = ColorSet.gray(.gray30).color
        $0.textColor = ColorSet.gray(.gray60).color
        $0.font = FontSet.button01.font
        $0.isUserInteractionEnabled = false
    }
    
    private let viewModel: DeleteAccountViewModel
    
    init(viewModel: DeleteAccountViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews([holdUserTitleLabel, imageView, holeUserDescriptionLabel,
                                   quoteConatinerView, precautionTitleLabel, precautionContainerView,
                                   checkPrecautionButton, deleteAccountButton])
        quoteConatinerView.addSubviews([leftQuotesIcon, quoteTextLabel, quoteMovieLabel, rightQuotesIcon])
        precautionContainerView.addSubviews([firstTextLabel, firstPrecautionLabel, secondTextLabel,
                                             secondPrecautionLabel, thirdTextLabel, thirdPrecautionLabel])
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalToSuperview().inset(getDefaultSafeAreaBottom())
        }
        
        containerView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        holdUserTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 40))
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(holdUserTitleLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.centerX.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 152))
        }
        
        holeUserDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 40))
        }
        
        quoteConatinerView.snp.makeConstraints {
            $0.top.equalTo(holeUserDescriptionLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.centerX.equalToSuperview()
        }
        
        quoteTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 20))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 32))
        }
        
        quoteMovieLabel.snp.makeConstraints {
            $0.top.equalTo(quoteTextLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        leftQuotesIcon.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 20))
        }
        
        rightQuotesIcon.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 20))
        }
        
        precautionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(quoteConatinerView.snp.bottom).offset(moderateScale(number: 40))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 24))
        }
        
        precautionContainerView.snp.makeConstraints {
            $0.top.equalTo(precautionTitleLabel.snp.bottom).offset(moderateScale(number: 12))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        firstTextLabel.snp.makeConstraints {
            $0.top.equalTo(firstPrecautionLabel)
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        firstPrecautionLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.leading.equalTo(firstTextLabel.snp.trailing)
        }
        
        secondTextLabel.snp.makeConstraints {
            $0.top.equalTo(secondPrecautionLabel)
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        secondPrecautionLabel.snp.makeConstraints {
            $0.top.equalTo(firstPrecautionLabel.snp.bottom).offset(moderateScale(number: 4))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.leading.equalTo(secondTextLabel.snp.trailing)
        }
        
        thirdTextLabel.snp.makeConstraints {
            $0.top.equalTo(thirdPrecautionLabel)
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        thirdPrecautionLabel.snp.makeConstraints {
            $0.top.equalTo(secondPrecautionLabel.snp.bottom).offset(moderateScale(number: 4))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.leading.equalTo(thirdTextLabel.snp.trailing)
            $0.bottom.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        checkPrecautionButton.snp.makeConstraints {
            $0.top.equalTo(precautionContainerView.snp.bottom).offset(moderateScale(number: 40))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.top.equalTo(checkPrecautionButton.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 52))
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupIfNeeded() {
        super.setupIfNeeded()
        
        setNavigationTitle(with: "회원 탈퇴하기")
        
        deleteAccountButton.didTapped { [weak self] in
            self?.viewModel.deleteAccount()
        }
    }
    
    private func bind() {
        checkPrecautionButton.getCheckPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isChecked in
                if isChecked {
                    self?.deleteAccountButton.backgroundColor = ColorSet.tertiary(.navy40).color
                    self?.deleteAccountButton.textColor = ColorSet.gray(.white).color
                    self?.deleteAccountButton.isUserInteractionEnabled = true
                } else {
                    self?.deleteAccountButton.backgroundColor = ColorSet.gray(.gray30).color
                    self?.deleteAccountButton.textColor = ColorSet.gray(.gray60).color
                    self?.deleteAccountButton.isUserInteractionEnabled = false
                }
            }.store(in: &cancelBag)
        
        viewModel.getDeleteAccountCompletedPublisher()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                CommonUtil.showAlertView(withType: .default,
                                         buttonType: .oneButton,
                                         title: "회원 탈퇴하기",
                                         description: "회원 탈퇴가 완료되었어요.\n언제든 돌아오세요.",
                                         submitCompletion: { [weak self] in
                    CommonUtil.topViewController()?.dismiss(animated: false)
                    self?.coordinator?.moveTo(appFlow: TabBarFlow.rank, userData: nil)
                }, cancelCompletion: nil)
            }.store(in: &cancelBag)
    }
}
