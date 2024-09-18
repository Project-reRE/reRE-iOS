//
//  ReportAlertViewController.swift
//  reRE
//
//  Created by 강치훈 on 9/18/24.
//

import UIKit
import Then
import SnapKit

final class ReportAlertViewController: UIViewController {
    private lazy var backgroundView = TouchableView().then {
        $0.backgroundColor = ColorSet.gray(.black).color?.withAlphaComponent(0.6)
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = ColorSet.gray(.gray20).color
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.clipsToBounds = true
    }
    
    private lazy var containerStackView = UIStackView().then {
        $0.spacing = moderateScale(number: 20)
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: moderateScale(number: 24),
                                        left: moderateScale(number: 16),
                                        bottom: moderateScale(number: 24),
                                        right: moderateScale(number: 16))
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "신고하기"
        $0.font = FontSet.title01.font
        $0.textColor = ColorSet.gray(.white).color
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var reasonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderateScale(number: 12)
    }
    
    private lazy var badWordReasonLabel = CheckMarkLabel().then {
        $0.titleLabel.text = "욕설 및 부적절한 표현"
    }
    
    private lazy var copyRightReasonLabel = CheckMarkLabel().then {
        $0.titleLabel.text = "저작권 침해"
    }
    
    private lazy var defamationReasonLabel = CheckMarkLabel().then {
        $0.titleLabel.text = "타인의 명예 훼손"
    }
    
    private lazy var sexualReasonLabel = CheckMarkLabel().then {
        $0.titleLabel.text = "성적인 내용"
    }
    
    private(set) lazy var reportButton = TouchableLabel().then {
        $0.text = "확인"
        $0.font = FontSet.button02.font
        $0.textColor = ColorSet.gray(.gray60).color
        $0.textAlignment = .center
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = ColorSet.gray(.gray30).color
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        addViews()
        makeConstraints()
        setupIfNeeded()
    }
    
    private func addViews() {
        view.addSubviews([backgroundView, containerView])
        containerView.addSubview(containerStackView)
        containerStackView.addArrangedSubviews([titleLabel, reasonStackView, reportButton])
        reasonStackView.addArrangedSubviews([badWordReasonLabel, copyRightReasonLabel,
                                             defamationReasonLabel, sexualReasonLabel])
    }
    
    private func makeConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.center.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        reportButton.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 44))
        }
    }
    
    private func setupIfNeeded() {
        backgroundView.didTapped { [weak self] in
            self?.dismiss(animated: false)
        }
        
        badWordReasonLabel.didTapped { [weak self] in
            guard let self = self else { return }
            
            if !self.badWordReasonLabel.isSelected {
                self.copyRightReasonLabel.selectLabel(isSelected: false)
                self.defamationReasonLabel.selectLabel(isSelected: false)
                self.sexualReasonLabel.selectLabel(isSelected: false)
            }
            
            self.badWordReasonLabel.selectLabel()
            self.checkSelection()
        }
        
        copyRightReasonLabel.didTapped { [weak self] in
            guard let self = self else { return }
            
            if !self.copyRightReasonLabel.isSelected {
                self.badWordReasonLabel.selectLabel(isSelected: false)
                self.defamationReasonLabel.selectLabel(isSelected: false)
                self.sexualReasonLabel.selectLabel(isSelected: false)
            }
            
            self.copyRightReasonLabel.selectLabel()
            self.checkSelection()
        }
        
        defamationReasonLabel.didTapped { [weak self] in
            guard let self = self else { return }
            
            if !self.defamationReasonLabel.isSelected {
                self.badWordReasonLabel.selectLabel(isSelected: false)
                self.copyRightReasonLabel.selectLabel(isSelected: false)
                self.sexualReasonLabel.selectLabel(isSelected: false)
            }
            
            self.defamationReasonLabel.selectLabel()
            self.checkSelection()
        }
        
        sexualReasonLabel.didTapped { [weak self] in
            guard let self = self else { return }
            
            if !self.sexualReasonLabel.isSelected {
                self.badWordReasonLabel.selectLabel(isSelected: false)
                self.copyRightReasonLabel.selectLabel(isSelected: false)
                self.defamationReasonLabel.selectLabel(isSelected: false)
            }
            
            self.sexualReasonLabel.selectLabel()
            self.checkSelection()
        }
    }
    
    private func checkSelection() {
        let emptySelection: Bool = [badWordReasonLabel, copyRightReasonLabel,
                                    defamationReasonLabel, sexualReasonLabel].allSatisfy { !$0.isSelected }
        
        if emptySelection {
            reportButton.isUserInteractionEnabled = false
            reportButton.textColor = ColorSet.gray(.gray60).color
            reportButton.backgroundColor = ColorSet.gray(.gray30).color
        } else {
            reportButton.isUserInteractionEnabled = true
            reportButton.textColor = ColorSet.gray(.white).color
            reportButton.backgroundColor = ColorSet.primary(.orange50).color
        }
    }
    
    func configureAlertView(submitCompletion: (() -> Void)?) {
        reportButton.didTapped { [weak self] in
            self?.dismiss(animated: false)
            submitCompletion?()
        }
    }
}
